/**
  * Copyright (c) 2014 Brian Korbein
  * This file is part of simple calc.
  *
  * simple calc is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * simple calc is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with simple calc.  If not, see <http://www.gnu.org/licenses/>.
*/
part of rpn;

///Parser recieves a string and converts it into an RPN friendly string.
///RPN friendly at this point means mostly converting the string into a list of
///lists [String type,String token]. This type annotation will allow operators,
///who will have the type "oper" to support more than just nums. I'm purposely
///avoiding using the actual dart types because it saves me needing to define
///classes for the types that don't exist in dart, like "oper", although there
///is an oper class, so that's a bad example. This will also save us from having
///to convert everything back into a string later. Being able to provide the
///shunting log to the output page means this class will need to maintain state
///It's pretty much the only one that does though.
class Parser {
  List<List<String>> tokens;
  String shuntingLog = ""; //this is "" when infix is turned off, or "" is passed in.
  RegExp _reg;
  ///Contruct a new Parser, which pretty much just means construct the regex...
  Parser(String uString, bool infix) {
    //dart regex is supposed to be identical to js regex, and this works for js
    //so it should work here as well.
    //to explain this regex...
    //The entire regex is wrapped by a single capture group, with each supported
    //types current regex or'd inside. The first regex is to match quoted
    //strings: "(?:[^"\\]|\\.)*" The double quotes at the start and end
    //signify the requirement to wrap all strings in quotes. Within the quotes
    //is a positive lookahead construct which has two sub regexes inside it
    //the first regex means roughly match anything that's not a double quote or
    //a backslash, the second says match any character (including double quote)
    //that is preceded by a backslash. This group can be repeated 0 or more
    //times within the two wrapping quotes. The second regex handles numbers,
    //this simpler regex just says, match any string of digits, possibly a '.'
    //followed by 0 or more digits, which means 1.0, 1, and 1. are all supported
    //numbers. The next regex \w+ covers any named operators, like max or min,
    //matching on any string of un-quoted word characters. The final regex \S
    //pulls in any lose characters left over, so things like + and - will be
    //matched. With the \S included there should never be any unmatched chars
    //in the string being matched against, although invalid constructs are
    //likely to appear one character at a time, so enjoy the strange behavior!
    _reg = new RegExp(r'("(?:[^"\\]|\\.)*"|\d+\.?\d*|\w+|\S)');
    _parse(uString, infix);
  }
  ///Parse takes a user supplied string and returns a list of lists ofstrings in
  ///RPN order for consumption by the calculator. This list is not validated,
  ///and will generally attempt to not throw any exceptions. The sublists
  ///returned are the annotated tokens, with current types being string, num and
  ///oper. The first element in the annotated lists is the type, the second is
  ///the value (type, value).
  void _parse(String uString, bool infix) {
    if(uString.length == 0){
      tokens = [["string",""]]; //create a list to return with a single empty string
    } else {
      if(infix){
        //Since this is
        List<String> tempToks = Shunting.infixToRPN(_rpnTokenize(uString));
        shuntingLog = tempToks.removeLast();
        tokens = _annotate(tempToks);
      } else {
      tokens = _annotate(_rpnTokenize(uString));
      }
    }
  }
  //Private method to create the tokens, this should only be called on a string
  //that actually has values...
  List<String> _rpnTokenize(String uString) {
    List<String> rString = new List<String>();
    //remove any sugar...
    uString = _deSugar(uString);
    var mat = _reg.allMatches(uString);
    //take the matches and blindly stuff them into the rString
    mat.forEach((val) {
      //since we currently only have a single group in the matcher, we can just
      //hardcode the 0 here, since we'll never regret that...
      rString.add(val.group(0));
    });
    return rString;
  }
  //Private method to remove syntactic sugar, like inline negation
  String _deSugar(String uString) {
    //turn inline negation into <number> neg
    return uString.replaceAllMapped(
        new RegExp(r'(-)(\d+)'),
        (Match m) => "${m[2]} neg");
  }
  //this is a fun type... list of list of strings, since dart doesn't support
  //tuple yet. the first inner list item will be the type, the second the token
  //aka (type, token)
  List<List<String>> _annotate(List<String> toks){
    //to make this work we're going to run the toks against an if-chain
    //that will annotate the token, and append it to the annoted list. The order
    //of the types here is potentially important, as  certain types can be
    //subsets of others. The most specific type should go first when this
    //happens so the annotator will select the correct type.
    List<List<String>> tated = new List<List<String>>();
    //Type Regexes
    //These are the components of the tokenizing regex that cover each type
    //and are explained above in the comment for that regex.
    RegExp str = new RegExp(r'("(?:[^"\\]|\\.)*")');
    RegExp nummy = new RegExp(r"(\d+\.?\d*)");
    RegExp oper = new RegExp(r"(\w+|\S)");


    //These are all going to look basically the same
    toks.forEach((t){
      if(_isType(str, t)){
        tated.add(["string", t]);
      } else if(_isType(nummy, t)){
        tated.add(["num", t]);
      } else if(_isType(oper, t)){
        tated.add(["oper", t]);
      } else {
        throw new Exception("Something went terribly wrong in the annotator."
            " Current token is: $t");
      }
    });
    return tated;
  }
  //Decide whether the given token is of the type defined by the given regex
  bool _isType(RegExp type, String token){
    //if we define the type regex correctly then the first match should be equal
    //to the given token
    if(type.firstMatch(token) == null){
      return false;
    } else {
      return type.firstMatch(token).group(0) == token;
    }
  }
}

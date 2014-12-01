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
///strings.
class Parser {
  RegExp _reg;
  ///Contruct a new Parser, which pretty much just means construct the regex...
  Parser() {
    //dart regex is supposed to be identical to js regex, and this works for js
    //so it should work here as well. This regex will match on any words,
    //numbers or symbols while ignoring whitespace
    _reg = new RegExp(r"(\w+|\S)");
  }
  ///Parse takes a user supplied string and returns a list of strings in RPN
  ///order for consumption by the calculator. This list is unvalidated, and
  ///will generally attempt to not throw any exceptions. An empty uString will
  ///be returned as a list containing a single empty string.
  List<String> parse(String uString) {
    List<String> rString;
    if (uString.length == 0) {
      rString = [""]; //create an list to return with a single empty string
    } else {
      rString = _rpnTokenize(uString);
    }
    return rString;
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
}

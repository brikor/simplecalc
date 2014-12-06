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

///Calc does all the actual work of performing calculations. To add additional
///operators just add them to the _oper Map. the calculator will use a factory
///constructor so it won't ever be duplicated. It's stateless so duplication
/// would be rather pointless, and consume extra memory.
class Calc {
  //make some named constants for the type and value of the tokens
  static const int TYPE = 0;
  static const int VALUE = 1;
  //map of all operators
  static final Map<String, Function> _oper = <String, Function>{};
  //cached Calc object
  static Calc _cal;

  ///Return a new Calc object, or a copy of the cached one if a new one hasn't
  ///been created.
  factory Calc() {
    if (_cal == null) {
      _cal = new Calc._internal();
    }
    return _cal;
  }
  //internal constructor, this is where you add new functions to the map...
  Calc._internal() {
    /**
     * The Functions should take a list of tokens, return the updated token
     * list, and throw if there are any issues. Beyond that, do what you want.
     * The opers can manipulate the list of tokens as they need, so long as it's
     * in a valid state when they're done.
     */

    //"+", returns the sum of the previous two numbers, or
    //two strings concatenated together
    _oper["+"] = (List<List<String>> tok, int pos) {
      //grab the preceding element, twice
      List<String> a = tok.removeAt(pos -2);
      List<String> b = tok.removeAt(pos -2);
      //we'll need to run through an if chain to cover all the support types of
      //addition (num+num, string+string, etc...)
      List<String> res;
      if (a[TYPE] == "num" && b[TYPE] == "num") {
        res = ["num", (num.parse(a[VALUE]) + num.parse(b[VALUE])).toString()];
      } else if (a[TYPE] == "string" && b[TYPE] == "string") {
        //trim off the trailing and leading double quotes, so the strings
        //stay valid.
        String trimA = a[VALUE].substring(0, (a[VALUE].length - 1));
        String trimB = b[VALUE].substring(1);
        res = ["String", trimA + trimB];
      } else {
        throw new Exception("Invalid Calculation, ${a[VALUE]} + ${b[VALUE]}");
      }
      //overwrite the oper element with the result
      tok[pos - 2] = res;
      return tok;
    };
    //"-" subtracts two numbers
    _oper["-"] = (List<List<String>> tok, int pos) {
      //grab the two preceding elements, maintaining order
      List<String> b = tok[pos - 1];
      List<String> a = tok[pos - 2];
      List<String> res;
      if (a[TYPE] == "num" && b[TYPE] == "num") {
        res = ["num", (num.parse(a[VALUE]) - num.parse(b[VALUE])).toString()];
      } else {
        throw new Exception("Invalid Calculation, ${a[VALUE]} - ${b[VALUE]}");
      }
      //clean up the tok list, remove the oper, and one element, just overwrite
      //the other
      tok[pos - 2] = res;
      tok.removeAt(pos);
      tok.removeAt(pos - 1);
      return tok;
    };
    _oper["neg"] = (List<List<String>> tok, int pos) {
      //grab the two preceding element
      List<String> b = tok.removeAt(pos - 1);
      //for now we only support nums, so just let num.parse throw the error
      //and go straight to inserting and returning the new value
      tok[pos - 1] = ["num", (-(num.parse(b[VALUE]))).toString()];
      return tok;
    };
  }
  ///calculate takes a list of rpn tokens (list of strings) and performs the
  ///requested calculations. The end result of the calculations is returned as
  ///a string. If [toks] is empty or contains only a single empty string
  ///calculate will return an empty string.
  String calculate(List<List<String>> toks) {
    if (toks.length == 0) {
      return "";
    } else if (toks.length == 1) {
      //if the length is one, there can be no calculation, but there might be an
      //error, so we'll check the type, returning the value if the type is one
      //of the data types, and throwing an error if the type is an oper.
      if (toks[0][TYPE] == "oper") {
        throw new Exception("Invalid input ${toks[0][VALUE]}");
      } else {
        return toks[0][VALUE];
      }
    }
    //now that the simple cases are handle, the fun can begin. We're going to
    //run through [tok], starting at the head. The algo here is super simple,
    //Just seek forward until you reach the end of the list, one token at a
    //time, calculating when an oper token is reached, this also resets the pos
    // since we've no way to know where the current position is.
    int pos = 0;
    while (toks.length != 1 && pos <= toks.length) {
      if (toks[pos][TYPE] == "oper") {
        toks = _oper[toks[pos][VALUE]](toks, pos);
        pos = 0;
      } else {
        pos++;
      }
    }
    //if we didn't get a valid set of toks, and there are multiple nums left,
    //the single here will break that, yay
    return toks.first[VALUE];
  }

}

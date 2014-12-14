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

///PlusOper defines the "+" operator, using the Oper interface.
class PlusOper implements Oper {
  //make some named constants for the type and value of the tokens. Annoyingly
  //the way inheritance works I can't put these in the parent, since it's
  //abstract, which means putting them, and this block of text in every oper
  //subclass so I remember that I can't put them in Oper. :(
  static const int TYPE = 0;
  static const int VALUE = 1;

  ///doCalc returns the sum of the previous two numbers, or
  ///two strings concatenated together, depending on input
  @override
  List<List<String>> doCalc(List<List<String>> toks, int pos) {
    //grab the preceding element, twice, doing this with -2 will keep them in
    //the same order. for addition that doesn't matter, but for concatination it
    //does
    List<String> a = toks.removeAt(pos - 2);
    List<String> b = toks.removeAt(pos - 2);
    //we'll need to run through an if chain to cover both supported types of
    //addition (num+num, string+string). If the number of supported types goes
    //up this might be worth methodizing.
    List<String> res;
    if (a[TYPE] == "num" && b[TYPE] == "num") {
      res = ["num", (num.parse(a[VALUE]) + num.parse(b[VALUE])).toString()];
    } else if (a[TYPE] == "string" && b[TYPE] == "string") {
      //trim off the trailing and leading double quotes, so the strings
      //stay valid.
      String trimA = a[VALUE].substring(0, (a[VALUE].length - 1));
      String trimB = b[VALUE].substring(1);
      res = ["string", trimA + trimB];
    } else {
      throw new Exception("Invalid Calculation, ${a[VALUE]} + ${b[VALUE]}");
    }
    //overwrite the oper element with the result
    toks[pos - 2] = res;
    return toks;
  }
}

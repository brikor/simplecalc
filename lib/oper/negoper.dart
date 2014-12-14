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

///NegOper defines the "neg" operator, using the Oper interface.
class NegOper implements Oper {
  //make some named constants for the type and value of the tokens. Annoyingly
  //the way inheritance works I can't put these in the parent, since it's
  //abstract, which means putting them, and this block of text in every oper
  //subclass so I remember that I can't put them in Oper. :(
  static const int TYPE = 0;
  static const int VALUE = 1;
  ///doCalc returns the negation of the previous number
  @override
  List<List<String>> doCalc(List<List<String>> toks, int pos) {
    if (toks[pos - 1][TYPE] == "num") {
      //under the unproven assumption that string manipulation is cheaper than
      //casting a number back and forth between string and num we're going to
      //skip the conversion and just add/remove a - to the front of the num
      //string as would normally happen in negation.
      if(toks[pos - 1][VALUE][0] == '-'){
        toks[pos - 1][VALUE] = toks[pos - 1][VALUE].substring(1);
      } else {
        toks[pos - 1][VALUE] = '-' + toks[pos - 1][VALUE];
      }

    } else {
      throw new Exception("Invalid Operation, cannot negate a"
          " ${toks[pos - 1][TYPE]}");
    }
    //don't forget to remove the operator...
    toks.removeAt(pos);
    return toks;
  }
}

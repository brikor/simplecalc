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

///MinusOper defines the "-" operator, using the Oper interface.
class MinusOper implements Oper {
  //make some named constants for the type and value of the tokens. Annoyingly
  //the way inheritance works I can't put these in the parent, since it's
  //abstract, which means putting them, and this block of text in every oper
  //subclass so I remember that I can't put them in Oper. :(
  static const int TYPE = 0;
  static const int VALUE = 1;
  ///doCalc returns the difference of the previous two numbers
  @override
  List<List<String>> doCalc(List<List<String>> toks, int pos) {
    //grab the preceding element, twice, doing this with -2 will keep them in
    //the same order, which is important for subtraction.
    List<String> a = toks.removeAt(pos - 2);
    List<String> b = toks.removeAt(pos - 2);
    List<String> res;
    if (a[TYPE] == "num" && b[TYPE] == "num") {
      //subtraction seems much more prone to ieee float garbage so before we
      //calculate we're going to define a useful precision by finding the
      //precision of both numbers, and selecting the greater, which should
      //report back all the useful digits. There may be some accuracy issues
      //for numbers that are using a large fractional part, but I can't really
      //see a way around that save making my own non-ieee floats.
      int prec = _getPrec(a,b);
      res = [
          "num",
          (num.parse(a[VALUE]) - num.parse(b[VALUE])).toStringAsFixed(prec)];
    } else {
      throw new Exception("Invalid Calculation, ${a[VALUE]} - ${b[VALUE]}");
    }
    //overwrite the oper element with the result
    toks[pos - 2] = res;
    return toks;
  }
  //returns the larger precision of the two numbers
  int _getPrec(List<String> a, List<String> b){
    //if we capture all characters after the '.' in a number, that should give
    //the precision. Yay regex, you solve all my problems.
    RegExp reg = new RegExp(r"\.(\d+)");
    int aPrec = reg.allMatches(a[VALUE]).first.group(1).length;
    int bPrec = reg.allMatches(b[VALUE]).first.group(1).length;
    return aPrec > bPrec ? aPrec : bPrec;
  }
}

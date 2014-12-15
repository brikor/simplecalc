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

  static String calculate(List<List<String>> toks) {
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
        toks = (new Oper(toks[pos][VALUE])).doCalc(toks, pos);
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

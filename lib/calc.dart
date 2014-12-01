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
  //map of all operators
  static final Map<String,Function> _oper = <String, Function>{};
  //cached Calc object
  static Calc _cal;

  ///Return a new Calc object, or a copy of the cached one if a new one hasn't
  ///been created.
  factory Calc(){
    if(_cal == null){
      _cal = new Calc._internal();
    }
    return _cal;
  }
  //internal constructor, this is where you add new functions to the map...
  Calc._internal(){
    /**
     * The Functions should take a list of numbers and return number, and throw
     * if there are any issues. Beyond that, do what you want. It should be
     * noted however that these opers are expected to be destructive, which is
     * to say, the [tok] elements involved in the oper's calculation should be
     * removed from [tok].
     */

    //"+", returns the sum of the previous two numbers
    _oper["+"] = (List<num> tok){
      return (tok.removeLast() + tok.removeLast());
    };
    _oper["-"] = (List<num> tok){
      //the order of the nums matters here so...
      num b = tok.removeLast();
      num a = tok.removeLast();
      return (a - b);
    };
    _oper["neg"] = (List<num> tok){
      return -(tok.removeLast());
    };
  }
  ///calculate takes a list of rpn tokens (list of strings) and performs the
  ///requested calculations. The end result of the calculations is returned as
  ///a string. If [tok] is empty or contains only a single empty string
  ///calculate will return an empty string.
  String calculate(List tok){
    if(tok.length == 0){
      return "";
    } else if(tok.length == 1){
      //if the length is one, there can be no calculation, but there might be an
      //error, so we'll burn some cycles to convert tok[0] to a num and back
      String temp = tok[0];
      if(temp == ""){
        return temp;
      } else {
        return (num.parse(temp)).toString();
      }
    }
    //now that the simple cases are handle, the fun can begin. We're going to
    //run through [tok], starting at the head, until it's empty. The algo here
    //is super simple, just unshift, check the type, then either bump it onto
    //the number list, or run the oper.
    List<num> nums = new List<num>();
    while(tok.length != 0){
      String first = tok.removeAt(0);
      if(_oper.containsKey(first)){
        nums.add(_oper[first](nums));
      } else {
        nums.add(num.parse(first));
      }
    }
    //if we didn't get a valid set of toks, and there are multiple nums left,
    //the single here will break that, yay
    return nums.single.toString();
  }

}
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

///The Oper class is intended to act much like a factory, doing very little
///itself. Oper's constructor will return the correct subclass to perform your
///desired calculation. If the requested operator does not exist, enjoy your
///exception! As an aside, all decimals are going to be using ieee 64bit doubles
///and it will be up to the individual child opers to deal with the resulting
///ieee floatyness. When implementing an operator try not to let too much
///.00000000005 type garbage to get into the token list.
abstract class Oper {
  //There's really no point to having multiple instances of the calculation
  //subclasses around, since they have no state, so I'm going to do a little
  //extra up front and cache the instances by their operator symbol.
  static final Map<String, Oper> _opCache = new Map<String, Oper>();

  ///returns the correct operator for the symbol, or throws an error if that
  ///symbol is not a valid operator.
  factory Oper(String symbol) {
    if (_opCache.containsKey(symbol)) {
      return _opCache[symbol];
    }
    //this is potentially going to be long and ugly, but there's really no way
    //around it, this case statement defines the list of "valid" operators. It
    //doesn't care about what types are involved, so getting a hit here doesn't
    //really mean your operation is valid, just that you passed in the right
    //symbol. If the request operator doesn't exist, this is where the exception
    //will come from.
    switch (symbol) {
      case "+":
        _opCache[symbol] = new PlusOper();
        return _opCache[symbol];
      case "-":
        _opCache[symbol] = new MinusOper();
        return _opCache[symbol];
      case "neg":
        _opCache[symbol] = new NegOper();
        return _opCache[symbol];

      default:
        throw new Exception("Unsupported operator.");
    }
  }
  ///The operator interface is really complex! Once you've a valid instance you
  ///call oper.doCalc and feed it your list of lists of strings and the
  ///position. .doCalc will either perform your calculation, returning your
  ///result as a list of lists of strings (Every time I type that, I curse the
  ///lack of tuple, but then cpp has me spoiled, with its having all the
  ///features, every single one ever). If your calculation is unsupported
  ///.doCalc will throw an exception, so feed .doCalc carefully.
  List<List<String>> doCalc(List<List<String>> tok, int pos);
}

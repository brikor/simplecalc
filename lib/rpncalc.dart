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
library rpn;

import 'package:polymer/polymer.dart';

part "parser.dart";
part "calc.dart";
/**
 * A Polymer based rpn calculator.
 */
@CustomTag('rpn-calc')
class RPNCalc extends PolymerElement {
  @published String formula = '';
  //since we only write to result, it can be just observable i think?
  @observable String result = '';

  Parser par;
  Calc cal;

  RPNCalc.created() : super.created() {
    //initialize the parser and calculator so calculate can calculate
    par = new Parser();
    cal  = new Calc();
  }
  ///Here we take the user inputted formula, pass it through a chain of methods
  ///and give the result of the calculation back to the user.
  void calculate() {
    result = cal.calculate(par.parse(formula));
  }
}
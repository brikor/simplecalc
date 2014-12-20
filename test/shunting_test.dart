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
part of rpn_test;
//unit test the shunting class.
void shunting_test() {
  group('Shunting', () {
    test("Shunting.infixToRPN handles empty strings", () {
      expect(Shunting.infixToRPN([""]), equals(['', ' | \n' '']));
    });
    test("Shunting.infixToRPN handles numbers", () {
      expect(Shunting.infixToRPN(["55"]), equals(['55', '55 | \n' '55']));
    });
    test("Shunting.infixToRPN handles negative numbers", () {
      expect(
          Shunting.infixToRPN(["55", "neg"]),
          equals(['55', 'neg', '55 | \n' '55 | neg\n' '55 neg']));
    });
    //these strings are going to get stupid fast :(
    test("Shunting.infixToRPN handles simple math", () {
      expect(
          Shunting.infixToRPN(["55", "+", "55"]),
          equals(['55', '55', '+', '55 | \n' '55 | +\n' '55 55 | +\n' '55 55 +']));
    });
    test("Shunting.infixToRPN handles simple math with pointless parens", () {
          expect(
              Shunting.infixToRPN(["(", "55", "+", "55", ")"]),
              equals([ '55', '55', '+', ' | (\n' '55 | (\n' '55 | +(\n' '55 55 | +(\n' '55 55 + | \n' '55 55 +' ]));
    });
  });
}

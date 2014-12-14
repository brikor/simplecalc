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

//unit test the oper class and its children. Since the children will only be
//used via the oper factory, that seems the logical place to test each operator

void oper_test() {
  group('Oper', () {
    test('Oper caching works', () {
      Oper op = new Oper("+");
      expect(op, equals(new Oper("+")));
    });
    test("Oper can find a valid operator", () {
      Oper op = new Oper("+");
      expect(
          op.doCalc([["num", "10"], ["num", "10"], ["oper", "+"]], 2),
          equals([["num", "20"]]));
    });
    test("Oper throws on invalid operators", () {
      expect(() => new Oper(")"), throwsException);
    });
  });
  // run through operplus's basic functionality
  group('PlusOper', () {
    Oper op = new Oper("+");
    test('plusoper can add numbers with decimals', () {
      expect(
          op.doCalc([["num", "10.1"], ["num", "10.1"], ["oper", "+"]], 2),
          equals([["num", "20.2"]]));
    });
    test('plusoper can add strings', () {
      expect(
          op.doCalc([["string", '"10.1"'], ["string", '"10.1"'], ["oper", "+"]], 2),
          equals([["string", '"10.110.1"']]));
    });
    test('plusoper cannot add strings to numbers', () {
      expect(
          () => op.doCalc([["string", '"10.1"'], ["num", "10.1"], ["oper", "+"]], 2),
          throwsException);
    });
  });
  group('MinusOper', () {
    Oper op = new Oper("-");
    test('minusoper can subtract numbers with decimals', () {
      expect(
          op.doCalc([["num", "10.1"], ["num", "9.2"], ["oper", "-"]], 2),
          equals([["num", "0.9"]]));
    });
    test('minusoper can subtract numbers with differing precisions', () {
      expect(
          op.doCalc([["num", "1011.1111"], ["num", "9.2"], ["oper", "-"]], 2),
          equals([["num", "1001.9111"]]));
    });
    test('minusoper can subtract numbers with no precision', () {
      expect(
          op.doCalc([["num", "10"], ["num", "9"], ["oper", "-"]], 2),
          equals([["num", "1"]]));
    });
    test('minusoper cannot handle strings', () {
      expect(
          () => op.doCalc([["string", '"1"'], ["string", '"1"'], ["oper", "-"]], 2),
          throwsException);
    });
    test('minusoper cannot substract numbers from strings', () {
      expect(
          () => op.doCalc([["string", '"10.1"'], ["num", "10.1"], ["oper", "-"]], 2),
          throwsException);
    });
    test('minusoper cannot substract strings from numbers', () {
      expect(
          () => op.doCalc([["num", "10.1"], ["string", '"10.1"'], ["oper", "-"]], 2),
          throwsException);
    });

  });
  group('NegOper', () {
    Oper op = new Oper("neg");
    test('negoper can negate numbers', () {
      expect(
          op.doCalc([["num", "10.1"], ["oper", "neg"]], 1),
          equals([["num", "-10.1"]]));
    });
    test('negoper cannot handle strings', () {
      expect(
          () => op.doCalc([["string", "10.1"], ["oper", "neg"]], 1),
          throwsException);
    });

  });
}

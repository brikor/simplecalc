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

//unit test the calc class
void calc_test(){
  Calc c = new Calc();
  group('Calc', () {
      test('Calc can be instantiated', () {
        expect(c.runtimeType, equals(Calc));
      });
      test('Calc can only be instantiated once', () {
        expect(c, equals(new Calc()));
      });
      test("Calc.calculate handles empty lists", () {
        expect(c.calculate([]), equals(""));
      });
      test("Calc.calculate handles lists of empty string", () {
        expect(c.calculate([""]), equals(""));
      });
      test("Calc.calculate handles lists of single values", () {
        expect(c.calculate(["10"]), equals("10"));
      });
      //make sure to wrap calculate in a ()=> since the exception test
      //matchers can't handle methods with args.
      test("Calc.calculate throws on bad data", () {
        expect(()=>c.calculate(["-"]), throwsFormatException);
      });
      test("Calc.calculate throws when you forget an operator", () {
              expect(()=>c.calculate(["10","10","10"]), throwsStateError);
      });
      test("Calc.calculate throws when you feed a bad operator, } in this case",
          () { expect(()=>c.calculate(["10","10","}"]), throwsFormatException);
      });

    });
  //tests for the various operators should go here
  group('Math', (){
    test("Calc.calculate can add", (){
                expect(c.calculate(["10","10","+"]), equals("20"));
        });
  });
}
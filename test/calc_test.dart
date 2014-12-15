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
      test("Calc.calculate handles empty lists", () {
        expect(Calc.calculate([]), equals(""));
      });
      test("Calc.calculate handles lists of empty string", () {
        expect(Calc.calculate([["string",""]]), equals(""));
      });
      test("Calc.calculate handles lists of single values", () {
        expect(Calc.calculate([["num","10"]]), equals("10"));
      });
      //make sure to wrap calculate in a ()=> since the exception test
      //matchers can't handle methods with args.
      test("Calc.calculate throws on bad data", () {
        expect(()=>Calc.calculate([["oper","-"]]), throwsException);
      });
      //just catch the throw, since there's no good matcher
      test("Calc.calculate throws when you forget an operator", () {
              expect(()=>Calc.calculate([["num","10"],["num","10"],["num","10"]]), throws);
      });
      //just catch the throw, there's no good matcher for no such operator
      test("Calc.calculate throws when you feed a bad operator, } in this case",
          () { expect(()=>Calc.calculate([["num","10"],["num","10"],["oper","}"]]), throws);
      });

    });
  //tests for the various operators should go here
  group('Math', (){
    test("Calc.calculate can add", (){
                expect(Calc.calculate([["num","10"],["num","10"],["oper","+"]]), equals("20"));
    });
    test("Calc.calculate can add strings", (){
                    expect(Calc.calculate([["string","\"hello,\""],
                                        ["string","\" world!\""],["oper","+"]]),
                                        equals("\"hello, world!\""));
    });
    test("Calc.calculate can negate", (){
                expect(Calc.calculate([["num","10"],["oper","neg"]]), equals("-10"));
    });
    test("Calc.calculate can subtract ", (){
                expect(Calc.calculate([["num","10"],["num","19"],["oper","-"]]), equals("-9"));
    });
  });
}
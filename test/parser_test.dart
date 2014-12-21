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

//unit test the parser class.
void parser_test() {
  group('Parser, RPN', () {
    test("Parser handles empty strings", () {
      expect((new Parser("", false)).tokens, equals([["string",""]]));
    });
    test("Parser handles simple strings", (){
      expect((new Parser("10 10 +", false)).tokens, equals([["num","10"],["num","10"],
                                         ["oper","+"]]));
    });
    test("Parser handles string types", (){
          expect((new Parser("\"hello,\" \" world!\" +", false)).tokens,
              equals([["string","\"hello,\""],["string","\" world!\""],
                                             ["oper","+"]]));
    });
    test("Parser handles string with - in them", (){
              expect((new Parser("\"3-3\"", false)).tokens,
                  equals([["string","\"3-3\""]]));
    });
    test("Parser.parse handles negative numbers", (){
      expect((new Parser("-1 -2 +", false)).tokens, equals([["num","1"],["oper","neg"],["num","2"],
                                         ["oper","neg"],["oper","+"]]));
    });
  });
  group('Parser, Infix', () {
      test("Parser handles empty strings", () {
        expect((new Parser("", true)).tokens, equals([["string",""]]));
      });
      test("Parser handles simple strings", (){
        expect((new Parser("10 + 10", true)).tokens, equals([["num","10"],["num","10"],
                                           ["oper","+"]]));
      });
      test("Parser handles string types", (){
            expect((new Parser("\"hello,\" + \" world!\"", true)).tokens,
                equals([["string","\"hello,\""],["string","\" world!\""],
                                               ["oper","+"]]));
      });
      test("Parser handles string with - in them", (){
                    expect((new Parser("\"3-3\"", false)).tokens,
                        equals([["string","\"3-3\""]]));
      });
      test("Parser.parse handles negative numbers", (){
        expect((new Parser("-1 + -2", true)).tokens, equals([["num","1"],["oper","neg"],["num","2"],
                                           ["oper","neg"],["oper","+"]]));
      });
    });
}

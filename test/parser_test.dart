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
  group('Parser', () {
    Parser p = new Parser();
    test('Parser can be Instantiated', () {
      expect(p.runtimeType, equals(Parser));
    });
    test("Parser.parse handles empty strings", () {
      expect(p.parse(""), equals([""]));
    });
    test("Parser.parse handles simple strings", (){
      expect(p.parse("10 10 +"), equals(["10","10","+"]));
    });
    test("Parser.parse handles negative numbers", (){
      expect(p.parse("-1 -2 +"), equals(["1","neg","2","neg","+"]));
    });
  });
}

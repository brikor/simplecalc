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
library rpn_test;

import "dart:html";
import "dart:async";
import "package:unittest/unittest.dart";
import "package:unittest/html_enhanced_config.dart" show
    useHtmlEnhancedConfiguration;
import "package:polymer/polymer.dart";
import "package:simplecalc/rpncalc.dart";

part "parser_test.dart";
part "calc_test.dart";
//use a seperate main method so all test methods can be executed in one main.
void main() {
  //let the unit test package setup the html parts for us.
  useHtmlEnhancedConfiguration();
  initPolymer().run(() {
    return Polymer.onReady.then((_) {
      rpncalc_test();
      parser_test();
      calc_test();
    });
  });
}
void rpncalc_test() {

  //The basic test group covers basic ui functionality
  group('simple', () {
    // the rpn-calc element is present
    test('Imported the rpn-calc element', () {
      expect(querySelector('rpn-calc'), isNotNull);
    });

    // the shadowroot element imported correctly
    test('Imported the rpn-calc element', () {
      expect((querySelector('rpn-calc').shadowRoot), isNotNull);
    });
    //grab the shadow root here, since we'll fail otherwise
    ShadowRoot shadow = querySelector('rpn-calc').shadowRoot;
    //and grab a copy of the RPNCalc object as well
    RPNCalc calc = (querySelector('rpn-calc') as RPNCalc);

    // can set the text area to a value
    test('formula TextArea is editable', () {
      (shadow.querySelector("#formula") as TextAreaElement).value = "10";
      expect(
          (shadow.querySelector("#formula") as TextAreaElement).value,
          equals("10"));
    });
    //input of 10 sets result to 10
    test('Submit sets result', () {
      calc.formula = "10";
      ButtonElement btn = shadow.querySelector("#calcbtn") as ButtonElement;
      btn.click();
      expect(calc.result, equals("10"));
      //expect(shadow.querySelector("#results").text, equals("(Results: 10)"));
    });
    //input of 10 creates output of 10
    test('Submit Creates Output', () {
      calc.formula = "10";
      return new Future(() {
        ButtonElement btn = shadow.querySelector("#calcbtn") as ButtonElement;
        btn.click();
        return new Future(() {
          expect(shadow.querySelector("#results").text, equals("(Result: 10)"));
        });
      });
    });

    // no input creates no output
    test('Blank Submit Outputs blank', () {
      calc.formula = "";
      return new Future(() {
        (shadow.querySelector("#calcbtn") as ButtonElement).click();
        return new Future(() {
          expect(shadow.querySelector("#results").text, equals("(Result: )"));
        });
      });
    });
  });
}

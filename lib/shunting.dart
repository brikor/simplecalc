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

///This class represents an implementation of the Shunting-yard algorithm. For
///details see: http://en.wikipedia.org/wiki/Shunting-yard_algorithm. To use the
///class all you need is an un-annotated list of tokens in infix format. The
///existing parser should be able to provide that, if it can't that's going to
///be something of a problem, and I should probably fix that. Shunting has a
///single static method (as far as you the user are concerned) [infixToRPN] that
///takes a lists of strings in infix order, and returns the same, in RPN
///order, with certain infix specific tokens, like '(' removed.
class Shunting {
  ///[infixToRPN], as the class description says, converts from infix to rpn.
  ///It also builds a nice little log that can be given back to the user.
  ///the log is inserted as the last list element and can be simply removed
  ///with .removeLast(), then given to the user.
  static List<String> infixToRPN(List<String> toks) {
    List<String> rpnToks = new List<String>();
    List<String> opStack = new List<String>();
    StringBuffer log = new StringBuffer();
    while (!toks.isEmpty) {
      String cur = toks.removeAt(0);
      if (_opTable.containsKey(cur)) {
        //yay an operator, now it gets complicated :(
        if (opStack.length > 0) {
          //deal with precedence, if the new operator has a higher precedence
          //then we put it at the head of the opstack, if it has a lower precedence
          //then we can add swap it with the head of the opStack and give the old
          //head to the rpntoks stack. We also have to make sure we don't accidentily
          //compare against an ( since, that has special handling, stupid infix
          print(opStack);
          if (opStack.first == "(" ||
              _opTable[opStack.first][0] < _opTable[cur][0]) {
            opStack.insert(0, cur);
          } else {
            rpnToks.add(opStack.first);
            opStack[0] = cur;
          }
        } else {
          opStack.add(cur); //yay, adding the first op
        }
      } else if(cur == "(") { //starting paren is simple
        opStack.insert(0, cur);
      } else if(cur == ")"){ //closing paren is less simple but not bad
        //this can throw if we get bad data, we might want to make that explicit
        while(opStack.first != "(" ){
          rpnToks.add(opStack.removeAt(0));
        }
        //and discard the (
        opStack.removeAt(0);
      } else {
        rpnToks.add(cur);
      }
      //I should probably make this a method, but 4 lines isn't too bad
      log.writeAll(rpnToks, " ");
      log.write(" | ");
      log.writeAll(opStack);
      log.write("\n");
    }
    //there are probably some operators left on the stack at this point, so
    //throw them onto the tail of the rpnToks stack
    rpnToks.addAll(opStack);
    log.writeAll(rpnToks, " "); //log the final rpnstack to show the user.
    print(log);
    rpnToks.add(log.toString());
    return rpnToks;
  }

  //The opTable has the precedence and associativity for the supported operators.
  //This is derived from the operator precedence rules for C, so when in doubt
  //test it in gcc. It should be noted the layout here is:
  //operator : precedence, associativity(left,right,special),
  //an associativity of left or right cover normal operators like +, -. Special
  //covers things like max() which aren't normal infix operators
  static Map<String, List> _opTable = {
    "neg": [2, "right"],
    "+": [1, "left"],
    "-": [1, "left"]
  };
}

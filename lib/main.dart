
import 'package:expression_language/expression_language.dart';

import 'package:stack/stack.dart' as stack;
import 'package:flutter/material.dart';
//import 'package:expressions/expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home: new Calculator()
    );
  }
}

class Calculator extends StatefulWidget {
  _CalculatorSate createState()=>_CalculatorSate();
}

class _CalculatorSate extends State<Calculator> {

  String text='0';
  String temp='';
  bool flag=false;

  Widget btn(btnText,Color color) {
          
      return Container(
        width: 75,
        height: 75,
        margin: EdgeInsets.only(bottom:25),
        child: new RaisedButton(
          child: Text(btnText,
          style: TextStyle(
            fontSize: 20,
            
          ),),
          textTheme: ButtonTextTheme.primary,
          padding: EdgeInsets.all(20),
          onPressed: ()=>calculate(btnText),
          color:color,
          shape: CircleBorder(),
          
        ),
      );
    }


  Widget build(BuildContext buildcn) {

    return Scaffold (

      appBar:null,
      backgroundColor: Colors.white,
      
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        
        children: <Widget>[
          
          Row(children: <Widget>[
            Padding(padding: EdgeInsets.all(75)),
            Expanded(child:Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 50.0
                
              
              ),

              textAlign: TextAlign.right,
              
            
             )
            
           ,)
          ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
             
            btn('AC',Color(0xffFF0000)),
            btn('C',Color(0xffDCDCDC)),
            btn('.',Colors.blue),
            btn('/',Colors.blue),
          ],) ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            btn('7',Color(0xffDCDCDC)),
            btn('8',Color(0xffDCDCDC)),
            btn('9',Color(0xffDCDCDC)),
            btn('*',Colors.blue),
          ],) ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            btn('4',Color(0xffDCDCDC)),
            btn('5',Color(0xffDCDCDC)),
            btn('6',Color(0xffDCDCDC)),
            btn('-',Colors.blue),
          ],) ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            btn('1',Color(0xffDCDCDC)),
            btn('2',Color(0xffDCDCDC)),
            btn('3',Color(0xffDCDCDC)),
            btn('+',Colors.blue),
          ],) ,
          Row(
            
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            btn('0',Color(0xffDCDCDC)),
            btn('(',Color(0xffDCDCDC)),
            btn(')',Color(0xffDCDCDC)),
            btn('=',Colors.blue),
            
          ],
          ) ,
        ]
        
      ),
    );

      
  }
  void calculate(btnText) {
    
    if(btnText=='AC') {
      temp="0";
    }
    else if(btnText=='C') {
      temp=text.substring(0,text.length-1);
      if(temp=="")
        temp="0";
    }
    else if(btnText=='=') {
    try {
    //temp=evaluate(text);
    var expressionGrammarDefinition = ExpressionGrammarParser({});
    var parser = expressionGrammarDefinition.build();
    var result = parser.parse(text);
 
    
    var expression = result.value as Expression;
    var value = expression.evaluate();
    temp=value.toString();
    
    }
    catch (e) {
        text='Error';
        
    }
    flag=true;
    }
    else {
      if(btnText=='.') {
        if(text.length==1&&text[text.length-1]=='0') {
          text+=btnText;
        }
      }
      if(flag==true || text=='0') {
         temp="";
         flag=false;
      }
      temp+=btnText;
      if(temp.endsWith('+')||temp.endsWith('^')||temp.endsWith('-')||temp.endsWith('*')||temp.endsWith('/')) {
        if(temp[temp.length-2]=='+'||temp[temp.length-2]=='^'||temp[temp.length-2]=='-'||temp[temp.length-2]=='*'||temp[temp.length-2]=='/') {
          temp=temp.substring(0,temp.length-2)+btnText;
        }
      }
    }
    setState(() {
      text=temp;
    });
  }
  
dynamic precedence(dynamic op){ 
    if(op == '+'||op == '-') 
    return 1; 
    if(op == '*'||op == '/') 
    return 2;
    if(op=='^')
    return 3; 
    return 0; 
} 
bool isdigit(String str,int i) {
 if(str.codeUnitAt(i)>=48&&str.codeUnitAt(i)<=57)
   return true;
  else
    return false;
}
// Function to perform arithmetic operations. 
dynamic applyOp(dynamic a, dynamic b, String op){
    
    switch(op){ 
        case '+': return a + b; 
        case '-': return a - b; 
        case '*': return a * b; 
        case '/': return a / b; 
        
        default: return "Error!";
    } 
    
} 
String evaluate(String tokens){ 
    int i; 
      
    // stack to store integer values. 
    stack.Stack <dynamic> values=stack.Stack();

      
    // stack to store operators. 
    stack.Stack <String> ops=stack.Stack(); 
      
    for(i = 0; i < tokens.length; i++){ 
          
        if(tokens[i] == '('){ 
            ops.push(tokens[i]); 
        } 
          
        
        else if(isdigit(tokens,i)){ 
            dynamic val = 0; 
              
            // There may be more than one 
            // digits in number. 
            while(i < tokens.length &&  
                        isdigit(tokens,i)) 
            { 
                val = (val*10) + (tokens.codeUnitAt(i)-48); 
                i++; 
            } 
              
            values.push(val); 
            i--;
        } 
          
        // Closing brace encountered, solve  
        // entire brace. 
        else if(tokens[i] == ')') 
        { 
            while(ops.isNotEmpty && ops.top() != '(') 
            { 
                dynamic val2 = values.top(); 
                values.pop(); 
                  
                dynamic val1 = values.top(); 
                values.pop(); 
                  
                String op = ops.top(); 
                ops.pop(); 
                  
                values.push(applyOp(val1, val2, op)); 
            } 
              
            // pop opening brace. 
            if(ops.isNotEmpty) 
               ops.pop(); 
        } 
        
        // Current token is an operator. 
        else
        { 
            // While top of 'ops' has same or greater  
            // precedence to current token, which 
            // is an operator. Apply operator on top  
            // of 'ops' to top two elements in values stack. 
            while(ops.isNotEmpty && precedence(ops.top()) 
                                >= precedence(tokens[i])){ 
                int val2 = values.top(); 
                values.pop(); 
                  
                int val1 = values.top(); 
                values.pop(); 
                  
                String op = ops.top(); 
                ops.pop(); 
                  
                values.push(applyOp(val1, val2, op)); 
            } 
              
            // Push current token to 'ops'. 
            ops.push(tokens[i]); 
        } 
    } 
      
    // Entire expression has been parsed at this 
    // point, apply remaining ops to remaining 
    // values. 
    while(ops.isNotEmpty){ 
        int val2 = values.top(); 
        values.pop(); 
                  
        int val1 = values.top(); 
        values.pop(); 
                  
        String op = ops.top(); 
        ops.pop(); 
                  
        values.push(applyOp(val1, val2, op)); 
    } 

    // Top of 'values' contains result, return it. 
    return values.top().toString(); 
} 
}


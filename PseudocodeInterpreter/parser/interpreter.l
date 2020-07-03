/*! 
  \file interpreter.l
  \brief Lexical or scanner file
*/
%{
#include <iostream>
#include <stdlib.h>



#include "../includes/macros.hpp"

/*
  IMPORTANT: must be written before interpreter.tab.h
*/
#include "../ast/ast.hpp"

#include "interpreter.tab.h"


#include "../error/error.hpp"

/* Table of symbols */
#include "../table/table.hpp"

#include "../table/numericVariable.hpp"

extern lp::Table table; //!< External Table of Symbols
/*********************************************/

extern int lineNumber; //!< External line counter

%}


/*! \name REGULAR DEFINITIONS  */

DIGIT  [0-9] 

LETTER [a-zA-Z]

NUMBER1 {DIGIT}+\.?
NUMBER2 {DIGIT}*\.{DIGIT}+
NUMBER3 {NUMBER2}[eE][+\-]{DIGIT}+

NUMBER 	{NUMBER1}|{NUMBER2}|{NUMBER3} 

IDENTIFIER  {LETTER}(_?{LETTER}|{DIGIT})*

%x ERROR COMMENT MULTI_COMMENT STRING CHECK_INTERNAL_QUOTATION

%option caseless

/*! \name REGULAR EXPRESSIONS  */
%%

"#"					{BEGIN MULTI_COMMENT;}
<MULTI_COMMENT>"#" 	{BEGIN 0;}
<MULTI_COMMENT>.|\n	{;}

"@"				{BEGIN COMMENT;}
<COMMENT>"\n"	{BEGIN 0;}
<COMMENT>.		{;}

[ \t] 	{ ; }

\n      { lineNumber++; }

";"		{ return SEMICOLON; }


","		{ return COMMA; }

{NUMBER}	{
				yylval.number = atof(yytext); 
				return NUMBER; 
			}



"'"     {BEGIN STRING;}
<STRING>[^'\\]       {yymore();}
<STRING>"\\"    {
					yymore(); 
					BEGIN CHECK_INTERNAL_QUOTATION;
				}

<STRING>"'" {	
				yytext[yyleng-1]='\0'; 
				yylval.string = strdup(yytext);
				BEGIN 0;
				return STRING;	
			}
				
<CHECK_INTERNAL_QUOTATION>[^\\]     {yymore(); BEGIN STRING;}
<CHECK_INTERNAL_QUOTATION>"/"    {yymore();}

"modulo"     { return MODULO; }			
"quotient"	{return QUOTIENT;}

"-"		{ return MINUS;  } 			
"+"		{ return PLUS;   } 			

"*"	    { return MULTIPLICATION; } 	
"/"     { return DIVISION; } 		

"**"	{return POWER;}

"("     { return LPAREN; } 			
")"	    { return RPAREN; } 			


":=" 	{ return ASSIGNMENT; }		


"="		{ return EQUAL; }			
"<>"	{ return NOT_EQUAL; }		
">="	{ return GREATER_OR_EQUAL; }
"<="	{ return LESS_OR_EQUAL; }	
">"		{ return GREATER_THAN; }	
"<"		{ return LESS_THAN; }		

"not"	{ return NOT; }				
"or"	{ return OR; }				
"and"	{ return AND; }				

"write"			{ return WRITE; }
"writestring"	{ return WRITESTRING; }

"read"			{ return READ; }
"readstring"	{ return READSTRING; }

"if"	{return IF;}
"then"	{return THEN;}
"else"	{return ELSE;}
"endif" {return ENDIF;}

"while" 	{return WHILE;}
"do" 		{return DO;}
"endwhile"	{return ENDWHILE;}

"repeat"	{return REPEAT;}
"until"		{return UNTIL;}

"for"		{return FOR;}
"from"		{return FROM;}
"to"		{return TO;}
"step"		{return STEP;}
"endfor"	{return ENDFOR;}

"clear"	{std::cout << CLEAR_SCREEN;}

{IDENTIFIER}   	{
					std::string identifier(yytext);
					yylval.identifier =  strdup(yytext); 

					/* If the identifier is not in the table of symbols then it is inserted */	
					if (table.lookupSymbol(identifier) == false)
					{
						/* 
							The identifier is inserted into the symbol table 
							as undefined Variable with value 0.0
						*/
						lp::NumericVariable *n = new lp::NumericVariable(identifier,VARIABLE,UNDEFINED,0.0);

						/* A pointer to the new NumericVariable is inserted into the table of symbols */
						table.installSymbol(n);

						return VARIABLE;
					}
					else 
					{
						lp::Symbol	*s = table.getSymbol(identifier);

						/*  If the identifier is in the table then its token is returned  */
						return s->getToken();
					}
				}

^# {
		std::cout <<  BIYELLOW;
		std::cout <<  ">>>>>>> End of program <<<<<<<";
		std::cout << std::endl;
		std::cout << RESET;
		return 0;
	}

<<EOF>> { return 0; }


.	{
		BEGIN(ERROR); 
		yymore();  
	}

<ERROR>[^0-9+\-*/()\^% \t\n\;a-zA-Z=<>!&]	{ /* MODIFIED in examples 5, 7, 15 */
								  /* NEW in example 3 */
								  /* 
									The current value of yytext 
									will be concatenated with the next character
								  */
									yymore(); 
								}

<ERROR>(.|\n)                { 
								/* NEW in example 3 */
								/* Rewind one position */
								yyless(yyleng-1); 

								/* Display the error message */
								warning("Lexical error", yytext);

								/* Restore the initial state */
   								BEGIN(INITIAL);
							}
%%


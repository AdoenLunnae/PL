/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_INTERPRETER_TAB_H_INCLUDED
# define YY_YY_INTERPRETER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    SEMICOLON = 258,
    IF = 259,
    THEN = 260,
    ELSE = 261,
    ENDIF = 262,
    WHILE = 263,
    DO = 264,
    ENDWHILE = 265,
    FOR = 266,
    FROM = 267,
    STEP = 268,
    TO = 269,
    ENDFOR = 270,
    REPEAT = 271,
    UNTIL = 272,
    WRITE = 273,
    WRITESTRING = 274,
    READ = 275,
    READSTRING = 276,
    ASSIGNMENT = 277,
    COMMA = 278,
    NUMBER = 279,
    BOOL = 280,
    VARIABLE = 281,
    UNDEFINED = 282,
    CONSTANT = 283,
    BUILTIN = 284,
    STRING = 285,
    OR = 286,
    AND = 287,
    NOT = 288,
    GREATER_OR_EQUAL = 289,
    LESS_OR_EQUAL = 290,
    GREATER_THAN = 291,
    LESS_THAN = 292,
    EQUAL = 293,
    NOT_EQUAL = 294,
    PLUS = 295,
    MINUS = 296,
    MULTIPLICATION = 297,
    DIVISION = 298,
    MODULO = 299,
    QUOTIENT = 300,
    LPAREN = 301,
    RPAREN = 302,
    PRINT = 303,
    UNARY = 304,
    POWER = 305
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 139 "interpreter.y" /* yacc.c:1909  */

  char * identifier; 				 /* NEW in example 7 */
  double number;
  bool logic;						 /* NEW in example 15 */
  char* string;
  lp::ExpNode *expNode;  			 /* NEW in example 16 */
  std::list<lp::ExpNode *>  *parameters;    // New in example 16; NOTE: #include<list> must be in interpreter.l, init.cpp, interpreter.cpp
  std::list<lp::Statement *> *stmts; /* NEW in example 16 */
  lp::Statement *st;				 /* NEW in example 16 */
  lp::AST *prog;					 /* NEW in example 16 */

#line 117 "interpreter.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_INTERPRETER_TAB_H_INCLUDED  */

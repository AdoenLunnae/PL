%{
    #include <stdio.h>
    #include "analisis.h"
%}
%option caseless

LETTER [a-zA-ZáÁéÉíÍóÓúÚñÑ]
DIGIT [0-9]
SPACE [ \t\n]
SPACES {SPACE}+
SCI_NOTATION {DIGIT}("."{DIGIT}+)?E[+\-]?{DIGIT}+
DECIMAL {DIGIT}+("."{DIGIT}+)?
NUMBER -?{SCI_NOTATION}|{DECIMAL}

%x COMMENT_MULTI COMMENT_SINGLE STRING CHECK_INTERNAL_QUOTATION CHECK_ID CHECK_ID_UNDERSCORE FINISH_INVALID_ID

%%
{LETTER}    {BEGIN CHECK_ID; yymore();}
<CHECK_ID>{LETTER}|{DIGIT}  {yymore();}
<CHECK_ID>"_"   {yymore(); BEGIN CHECK_ID_UNDERSCORE;}
<CHECK_ID>{SPACE} {yytext[yyleng-1]='\0'; fprintf(yyout, "\nIdentificador: %s --> token: %d\n", yytext, IDENT); BEGIN 0;}
<CHECK_ID>. {yymore(); fprintf(yyout, "\nError, caracter no admitido en un identificador: \"%c\"", yytext[yyleng-1]); BEGIN FINISH_INVALID_ID;}

<CHECK_ID_UNDERSCORE>{LETTER}|{DIGIT}  {yymore(); BEGIN CHECK_ID;}
<CHECK_ID_UNDERSCORE>{SPACE} {fprintf(yyout, "\nError, un identificador no puede acabar en subrayado\nIdentificador INVALIDO: %s -->token: %d\n", yytext, INVALID); BEGIN 0;}
<CHECK_ID_UNDERSCORE>"_"    {yymore(); fprintf(yyout, "\nError, mas de un subrayado seguido en un identificador."); BEGIN FINISH_INVALID_ID;}
<CHECK_ID_UNDERSCORE>.  {yymore(); fprintf(yyout, "\nError, caracter no admitido en un identificador."); BEGIN FINISH_INVALID_ID;}

<FINISH_INVALID_ID>{SPACE} {yytext[yyleng-1]='\0'; fprintf(yyout, "\nIdentificador INVALIDO: %s --> token: %d\n", yytext, INVALID); BEGIN 0;}
<FINISH_INVALID_ID>. {yymore();}

"(*"    {BEGIN COMMENT_MULTI;}
<COMMENT_MULTI>"*)"     {BEGIN 0;}
<COMMENT_MULTI>.|\n     {;}

"#"     {BEGIN COMMENT_SINGLE;}
<COMMENT_SINGLE>"\n"    {BEGIN 0;}
<COMMENT_SINGLE>.    {;}

"'"     {BEGIN STRING;}
<STRING>[^'\\]       {yymore();}
<STRING>"\\"    {yymore(); BEGIN CHECK_INTERNAL_QUOTATION;}
<STRING>"'"     {yytext[yyleng-1]='\0'; BEGIN 0; fprintf(yyout, "\nCadena: %s --> token %d\n", yytext, CADENA);}
<CHECK_INTERNAL_QUOTATION>[^\\]     {yymore(); BEGIN STRING;}
<CHECK_INTERNAL_QUOTATION>"/"    {yymore();}

inicio  {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, INICIO);}
fin    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, FIN);}

escribir    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, ESCRIBIR);}
leer    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, LEER);}

si    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, SI);}
entonces    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, ENTONCES);}
si_no    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, SINO);}
fin_si    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, FINSI);}

mientras    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, MIENTRAS);}
hacer    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, HACER);}
fin_mientras    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, FINMIENTRAS);}

repetir    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, REPETIR);}
hasta_que    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, HASTA_QUE);}

para    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, PARA);}
desde   {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, DESDE);}
hasta    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, HASTA);}
paso    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, PASO);}
fin_para    {fprintf(yyout, "\nPalabra reservada: %s --> token %d\n", yytext, FINPARA);}

{NUMBER}    {fprintf(yyout, "\nNumero: %s --> token %d\n", yytext, NUMERO);}

":="    {fprintf(yyout, "\nOperador de asignación: %s --> token %d\n", yytext, ASIGNA);}

"+"    {fprintf(yyout, "\nOperador aritmético: %s --> token %d\n", yytext, SUMA);}
"-"    {fprintf(yyout, "\nOperador aritmético: %s --> token %d\n", yytext, RESTA);}
"**"    {fprintf(yyout, "\nOperador aritmético: %s --> token %d\n", yytext, POW);}
"*"    {fprintf(yyout, "\nOperador aritmético: %s --> token %d\n", yytext, MULT);}
"/"    {fprintf(yyout, "\nOperador aritmético: %s --> token %d\n", yytext, DIV);}
"__mod"    {fprintf(yyout, "\nOperador aritmético: %s --> token %d\n", yytext, MOD);}

"<"     {fprintf(yyout, "\nOperador Relacional: %s --> token %d\n", yytext, MENOR_QUE);}
"<="     {fprintf(yyout, "\nOperador Relacional: %s --> token %d\n", yytext, MENOR_IGUAL);}
">"     {fprintf(yyout, "\nOperador Relacional: %s --> token %d\n", yytext, MAYOR_QUE);}
">="     {fprintf(yyout, "\nOperador Relacional: %s --> token %d\n", yytext, MAYOR_IGUAL);}
"=="     {fprintf(yyout, "\nOperador Relacional: %s --> token %d\n", yytext, IGUAL);}
"<>"     {fprintf(yyout, "\nOperador Relacional: %s --> token %d\n", yytext, DISTINTO);}

"||"    {fprintf(yyout, "\nOperador alfanumerico: %s --> token %d\n", yytext, CONCAT);}

".o."   {fprintf(yyout, "\nOperador Lógico: %s --> token %d\n", yytext, DISYUNCION);}
".y."   {fprintf(yyout, "\nOperador Lógico: %s --> token %d\n", yytext, CONJUNCION);}
".no."   {fprintf(yyout, "\nOperador Lógico: %s --> token %d\n", yytext, NEGACION);}

"("     {fprintf(yyout, "\nComponente léxico: %s --> token %d\n", yytext, PAR_IZQ);}
")"     {fprintf(yyout, "\nComponente léxico: %s --> token %d\n", yytext, PAR_DER);}
";"     {fprintf(yyout, "\nComponente léxico; %s --> token %d\n", yytext, FIN_SENTENCIA);}

{SPACES}    {;}
.   ECHO;

%%
int main(int argc, char **argv)
{
    extern FILE *yyin, *yyout;
    if(argc >= 2){
        if(!(yyin = fopen(argv[1], "r"))){
            perror("Error opening input");
            exit(1);
        }
        if((argc == 3) && !(yyout = fopen(argv[2], "w"))){
            perror("Error opening output");
            exit(1);
        }
        yylex();
    }
    else{
        printf("Usage: %s <input_file> [output_file]\n", argv[0]);
        return(1);
    }
    return(0);
}
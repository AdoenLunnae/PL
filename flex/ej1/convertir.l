%{
    #include<stdio.h>
%}

DIGIT   [0-9]
%%
{DIGIT}+"."{DIGIT}+  ECHO;
{DIGIT}+          { fprintf(yyout, "%.1f", (float)atoi(yytext)); }
%%
int main(int argc, char **argv)
{
    extern FILE *yyin, *yyout;
    if(argc == 3){
        if(!(yyin = fopen(argv[1], "r"))){
            perror("Error opening input");
            exit(1);
        }
        if(!(yyout = fopen(argv[2], "w"))){
            perror("Error opening output");
            exit(1);
        }
        yylex();
    }
    else{
        printf("Usage: %s <input_file> <output_file>", argv[0]);
        return(1);
    }
    return(0);
}
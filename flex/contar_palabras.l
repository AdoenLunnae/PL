%{
    int count = 0, countWord = 0;
    char targetWord[100];
%}

ALPHA  [a-zA-ZáéíóúÁÉÍÓÚñÑ]
%%
{ALPHA}+   {count++; if(strcmp(yytext, targetWord) == 0){countWord++;}}
.|\n           ;
%%

int main(int argc, char **argv)
{
    extern FILE *yyin;
    if(argc >= 2){
        if(!(yyin = fopen(argv[1], "r"))){
            perror("Error opening input");
            exit(1);
        }
        if(argc == 3){
            strcpy(targetWord, argv[2]);
        }
        yylex();
        if(argc == 3)
            printf("El fichero %s contiene la palabra \"%s\" %d %s\n", argv[1], argv[2], countWord, (countWord==1)?"vez":"veces");
        else
            printf("El fichero %s contiene %d palabras\n", argv[1], count);
    }
    else{
        printf("Usage: %s <input_file> [TARGET_WORD]", argv[0]);
        return(1);
    }
    return(0);
}
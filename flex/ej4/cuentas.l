%{
    #include<stdio.h>
    #include<string.h>
    int countTotal, countCountry , countBank, countOffice, keepComparing;
    char targetCountry[20], targetBank[20], targetOffice[20];
    int compCountry, compBank, compOffice;
%}

LETTER [A-Za-z]
NUMBER [0-9]

COUNTRY_CODE {LETTER}{LETTER}
XY {NUMBER}{NUMBER}

BANK {NUMBER}{NUMBER}{NUMBER}{NUMBER}

OFFICE {NUMBER}{NUMBER}{NUMBER}{NUMBER}

CONTROL_DIGITS {NUMBER}{NUMBER}

ACCOUNT {NUMBER}{NUMBER}{NUMBER}{NUMBER}{NUMBER}{NUMBER}{NUMBER}{NUMBER}{NUMBER}{NUMBER}


%x SCAN_COUNTRY SCAN_XY SCAN_BANK SCAN_OFFICE SCAN_CONTROL SCAN_ACCOUNT FINISH_LINE

%%
    BEGIN(SCAN_COUNTRY);

<FINISH_LINE>.     {;}
<FINISH_LINE>"\n"   {BEGIN(SCAN_COUNTRY);}

<SCAN_COUNTRY>{COUNTRY_CODE}    {
    keepComparing = 1;
    if(compCountry && (strcmp(targetCountry, yytext) == 0)){
        countCountry++;
    }
    else{
        keepComparing = 0;
    };
    BEGIN(SCAN_XY);
}
<SCAN_COUNTRY>.    {printf("Código de país inválido"); BEGIN(FINISH_LINE);}

<SCAN_XY>{XY}" "   {BEGIN(SCAN_BANK);}
<SCAN_XY>.|"\n" {printf("Identificador de país inválido"); BEGIN(FINISH_LINE);}

<SCAN_BANK>{BANK}" " {
    yytext[yyleng - 1] = '\0';
    if(compBank && keepComparing && (strcmp(targetBank, yytext) == 0)){
        countBank++;
    }
    else{
        keepComparing = 0;
    }
    BEGIN(SCAN_OFFICE);
}
<SCAN_BANK>.|"\n" {printf("Código de entidad incorrecto: <<%s>>\n", yytext); BEGIN(FINISH_LINE);}

<SCAN_OFFICE>{OFFICE}" " {
    yytext[yyleng - 1] = '\0';
    if(compOffice && keepComparing && (strcmp(targetOffice, yytext) == 0)){
        countOffice++;
    }
    else{
        keepComparing = 0;
    }
    BEGIN(SCAN_CONTROL);
}
<SCAN_OFFICE>.|"\n" {printf("Código de oficina incorrecto"); BEGIN(FINISH_LINE);}

<SCAN_CONTROL>{CONTROL_DIGITS}" " {
    BEGIN(SCAN_ACCOUNT);
}
<SCAN_CONTROL>.|"\n" {printf("Dígitos de control incorrectos"); BEGIN(FINISH_LINE);}

<SCAN_ACCOUNT>{ACCOUNT}"\n" {
    countTotal++;
    BEGIN(SCAN_COUNTRY);
}
<SCAN_ACCOUNT>. {printf("Número de cuenta incorrecto"); BEGIN(FINISH_LINE);}

%%

int main(int argc, char **argv)
{
    extern FILE *yyin;
    extern int countTotal, countCountry, countBank, countOffice;
    extern int compCountry, compBank, compOffice;
    countTotal=0, countCountry=0, countBank=0, countOffice=0;
    compCountry=0, compBank=0, compOffice=0;
    if(argc >= 2){
        if(!(yyin = fopen(argv[1], "r"))){
            perror("Error opening input");
            exit(1);
        }
        switch(argc){
            case 2:
            {
                yylex();
                printf("Número total de cuentas: %d\n", countTotal);
            }break;

            case 3:
            {
                compCountry=1;
                strncpy(targetCountry, argv[2], 20);

                yylex();

                printf("Número total de cuentas de %s: %d\n", targetCountry, countCountry);
            }break;

            case 4:
            {
                compCountry=1;
                compBank=1;
                strncpy(targetCountry, argv[2], 20);
                strncpy(targetBank, argv[3], 20);

                yylex();

                printf("Número total de cuentas de %s %s: %d\n", targetCountry, targetBank, countBank);

            }break;

            case 5:
            {
                compCountry=1;
                compBank=1;
                compOffice=1;
                strncpy(targetCountry, argv[2], 20);
                strncpy(targetBank, argv[3], 20);
                strncpy(targetOffice, argv[4], 20);

                yylex();

                printf("Número total de cuentas de %s %s: %d\n", targetCountry, targetBank, countOffice);

            }break;
        }
    }
    else{
        printf("Uso: %s <fichero> [PAÍs] [ENTIDAD] [OFICINA]", argv[0]);
        return(1);
    }
    return(0);
}
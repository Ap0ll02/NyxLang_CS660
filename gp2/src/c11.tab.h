/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_C11_TAB_H_INCLUDED
# define YY_YY_C11_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    SIZEOF = 258,                  /* SIZEOF  */
    PTR_OP = 259,                  /* PTR_OP  */
    INC_OP = 260,                  /* INC_OP  */
    DEC_OP = 261,                  /* DEC_OP  */
    TYPEDEF_NAME = 262,            /* TYPEDEF_NAME  */
    TYPEDEF = 263,                 /* TYPEDEF  */
    EXTERN = 264,                  /* EXTERN  */
    STATIC = 265,                  /* STATIC  */
    AUTO = 266,                    /* AUTO  */
    REGISTER = 267,                /* REGISTER  */
    INLINE = 268,                  /* INLINE  */
    CONST = 269,                   /* CONST  */
    RESTRICT = 270,                /* RESTRICT  */
    VOLATILE = 271,                /* VOLATILE  */
    CHAR = 272,                    /* CHAR  */
    SHORT = 273,                   /* SHORT  */
    LONG = 274,                    /* LONG  */
    SIGNED = 275,                  /* SIGNED  */
    UNSIGNED = 276,                /* UNSIGNED  */
    VOID = 277,                    /* VOID  */
    COMPLEX = 278,                 /* COMPLEX  */
    IMAGINARY = 279,               /* IMAGINARY  */
    ENUM = 280,                    /* ENUM  */
    ELLIPSIS = 281,                /* ELLIPSIS  */
    CASE = 282,                    /* CASE  */
    DEFAULT = 283,                 /* DEFAULT  */
    IF = 284,                      /* IF  */
    ELSE = 285,                    /* ELSE  */
    SWITCH = 286,                  /* SWITCH  */
    WHILE = 287,                   /* WHILE  */
    DO = 288,                      /* DO  */
    FOR = 289,                     /* FOR  */
    GOTO = 290,                    /* GOTO  */
    CONTINUE = 291,                /* CONTINUE  */
    BREAK = 292,                   /* BREAK  */
    RETURN = 293,                  /* RETURN  */
    ALIGNAS = 294,                 /* ALIGNAS  */
    ALIGNOF = 295,                 /* ALIGNOF  */
    ATOMIC = 296,                  /* ATOMIC  */
    NORETURN = 297,                /* NORETURN  */
    STATIC_ASSERT = 298,           /* STATIC_ASSERT  */
    THREAD_LOCAL = 299,            /* THREAD_LOCAL  */
    INT = 300,                     /* INT  */
    FLOAT = 301,                   /* FLOAT  */
    STRUCT = 302,                  /* STRUCT  */
    UNION = 303,                   /* UNION  */
    MUL_ASSIGN = 304,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 305,              /* DIV_ASSIGN  */
    MOD_ASSIGN = 306,              /* MOD_ASSIGN  */
    ADD_ASSIGN = 307,              /* ADD_ASSIGN  */
    SUB_ASSIGN = 308,              /* SUB_ASSIGN  */
    LEFT_ASSIGN = 309,             /* LEFT_ASSIGN  */
    RIGHT_ASSIGN = 310,            /* RIGHT_ASSIGN  */
    AND_ASSIGN = 311,              /* AND_ASSIGN  */
    XOR_ASSIGN = 312,              /* XOR_ASSIGN  */
    OR_ASSIGN = 313,               /* OR_ASSIGN  */
    DOUBLE = 314,                  /* DOUBLE  */
    IDENTIFIER = 315,              /* IDENTIFIER  */
    STRING_LITERAL = 316,          /* STRING_LITERAL  */
    ENUMERATION_CONSTANT = 317,    /* ENUMERATION_CONSTANT  */
    FUNC_NAME = 318,               /* FUNC_NAME  */
    GENERIC = 319,                 /* GENERIC  */
    INT_CONST = 320,               /* INT_CONST  */
    I_CONSTANT = 321,              /* I_CONSTANT  */
    FLOAT_CONST = 322,             /* FLOAT_CONST  */
    F_CONSTANT = 323,              /* F_CONSTANT  */
    DOUBLE_CONST = 324,            /* DOUBLE_CONST  */
    BOOL = 325,                    /* BOOL  */
    LE_OP = 326,                   /* LE_OP  */
    GE_OP = 327,                   /* GE_OP  */
    EQ_OP = 328,                   /* EQ_OP  */
    NE_OP = 329,                   /* NE_OP  */
    AND_OP = 330,                  /* AND_OP  */
    OR_OP = 331,                   /* OR_OP  */
    LEFT_OP = 332,                 /* LEFT_OP  */
    RIGHT_OP = 333                 /* RIGHT_OP  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 70 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"

	int intval;
	float fval;
	double doubleval;
	char *id; // magic that works
	// char charval;
    struct Node* node;
    enum yytokentype yyt_type;

#line 152 "c11.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_C11_TAB_H_INCLUDED  */

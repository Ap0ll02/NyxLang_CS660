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
    MUL_ASSIGN = 262,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 263,              /* DIV_ASSIGN  */
    MOD_ASSIGN = 264,              /* MOD_ASSIGN  */
    ADD_ASSIGN = 265,              /* ADD_ASSIGN  */
    SUB_ASSIGN = 266,              /* SUB_ASSIGN  */
    LEFT_ASSIGN = 267,             /* LEFT_ASSIGN  */
    RIGHT_ASSIGN = 268,            /* RIGHT_ASSIGN  */
    AND_ASSIGN = 269,              /* AND_ASSIGN  */
    XOR_ASSIGN = 270,              /* XOR_ASSIGN  */
    OR_ASSIGN = 271,               /* OR_ASSIGN  */
    TYPEDEF_NAME = 272,            /* TYPEDEF_NAME  */
    TYPEDEF = 273,                 /* TYPEDEF  */
    EXTERN = 274,                  /* EXTERN  */
    STATIC = 275,                  /* STATIC  */
    AUTO = 276,                    /* AUTO  */
    REGISTER = 277,                /* REGISTER  */
    INLINE = 278,                  /* INLINE  */
    CONST = 279,                   /* CONST  */
    RESTRICT = 280,                /* RESTRICT  */
    VOLATILE = 281,                /* VOLATILE  */
    CHAR = 282,                    /* CHAR  */
    SHORT = 283,                   /* SHORT  */
    LONG = 284,                    /* LONG  */
    SIGNED = 285,                  /* SIGNED  */
    UNSIGNED = 286,                /* UNSIGNED  */
    VOID = 287,                    /* VOID  */
    COMPLEX = 288,                 /* COMPLEX  */
    IMAGINARY = 289,               /* IMAGINARY  */
    STRUCT = 290,                  /* STRUCT  */
    UNION = 291,                   /* UNION  */
    ENUM = 292,                    /* ENUM  */
    ELLIPSIS = 293,                /* ELLIPSIS  */
    CASE = 294,                    /* CASE  */
    DEFAULT = 295,                 /* DEFAULT  */
    IF = 296,                      /* IF  */
    ELSE = 297,                    /* ELSE  */
    SWITCH = 298,                  /* SWITCH  */
    WHILE = 299,                   /* WHILE  */
    DO = 300,                      /* DO  */
    FOR = 301,                     /* FOR  */
    GOTO = 302,                    /* GOTO  */
    CONTINUE = 303,                /* CONTINUE  */
    BREAK = 304,                   /* BREAK  */
    RETURN = 305,                  /* RETURN  */
    ALIGNAS = 306,                 /* ALIGNAS  */
    ALIGNOF = 307,                 /* ALIGNOF  */
    ATOMIC = 308,                  /* ATOMIC  */
    NORETURN = 309,                /* NORETURN  */
    STATIC_ASSERT = 310,           /* STATIC_ASSERT  */
    THREAD_LOCAL = 311,            /* THREAD_LOCAL  */
    INT = 312,                     /* INT  */
    FLOAT = 313,                   /* FLOAT  */
    IDENTIFIER = 314,              /* IDENTIFIER  */
    STRING_LITERAL = 315,          /* STRING_LITERAL  */
    ENUMERATION_CONSTANT = 316,    /* ENUMERATION_CONSTANT  */
    FUNC_NAME = 317,               /* FUNC_NAME  */
    GENERIC = 318,                 /* GENERIC  */
    INT_CONST = 319,               /* INT_CONST  */
    I_CONSTANT = 320,              /* I_CONSTANT  */
    FLOAT_CONST = 321,             /* FLOAT_CONST  */
    F_CONSTANT = 322,              /* F_CONSTANT  */
    DOUBLE_CONST = 323,            /* DOUBLE_CONST  */
    DOUBLE = 324,                  /* DOUBLE  */
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
#line 63 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"

	int intval;
	float floatval;
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

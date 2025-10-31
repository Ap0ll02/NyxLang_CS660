/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"

#include "c11.tab.h"
#include <stdio.h>
#include <stdint.h>
// FUNCTION DECLARATIONS: 
enum yytokentype;
int yydebug = 1;
int yylex(void);
int yyparse(void);
void yyerror(const char *s);
// External Functions

// Symbol Table Functions

void zig_error();

// So we can return generic node pointers and other values
struct Node* node;
struct Node* make_identifier_node(const char *s);
struct Node* make_declaration_node(struct Node* typeNode, struct Node* asgnNode);
struct Node* make_constant_node(int s);
struct Node* make_type_node(enum yytokentype token);
struct Node* make_assignment_node(struct Node* declarator, struct Node* initializer);
struct Node* make_conditional_expression_node(struct Node* expr1, enum yytokentype token, struct Node* expr2);
struct Node* make_binary_node(struct Node* left, char operator, struct Node* right);
struct Node* make_expr_stmt(struct Node* expr);
struct Node* append_block_list(struct Node* item, struct Node* items);
struct Node* make_if_stmt(struct Node* cond, struct Node* if_branch, struct Node* else_branch);
struct Node* make_iteration_stmt(struct Node* cond, struct Node* body, struct Node* init, struct Node* post);
struct Node* append_parameter_list(struct Node* item, struct Node* items);
struct Node* make_name_parameter_node(struct Node* identifier, struct Node* parameterList);
struct Node* make_function_node(struct Node* retType, struct Node* nameParameter, struct Node* body);
struct Node* make_pointer_node(struct Node* pointee);
struct Node* make_idpointer_node(struct Node* pointer, struct Node* id);
struct Node* make_function_call_node(struct Node* name, struct Node* args);
struct Node* append_argument_list(struct Node* item, struct Node* items);
struct Node* make_string_node(const char* s);
struct Node* make_return_node(struct Node* ret_val);
struct Node* append_struct_decl_list(struct Node* member, struct Node* members);
struct Node* append_struct_declarator_list(struct Node* declarator, struct Node* declarators);
void make_struct_decl(struct Node* typeNode, struct Node* members);
extern struct Node* root;

#line 115 "c11.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "c11.tab.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_SIZEOF = 3,                     /* SIZEOF  */
  YYSYMBOL_PTR_OP = 4,                     /* PTR_OP  */
  YYSYMBOL_INC_OP = 5,                     /* INC_OP  */
  YYSYMBOL_DEC_OP = 6,                     /* DEC_OP  */
  YYSYMBOL_MUL_ASSIGN = 7,                 /* MUL_ASSIGN  */
  YYSYMBOL_DIV_ASSIGN = 8,                 /* DIV_ASSIGN  */
  YYSYMBOL_MOD_ASSIGN = 9,                 /* MOD_ASSIGN  */
  YYSYMBOL_ADD_ASSIGN = 10,                /* ADD_ASSIGN  */
  YYSYMBOL_SUB_ASSIGN = 11,                /* SUB_ASSIGN  */
  YYSYMBOL_LEFT_ASSIGN = 12,               /* LEFT_ASSIGN  */
  YYSYMBOL_RIGHT_ASSIGN = 13,              /* RIGHT_ASSIGN  */
  YYSYMBOL_AND_ASSIGN = 14,                /* AND_ASSIGN  */
  YYSYMBOL_XOR_ASSIGN = 15,                /* XOR_ASSIGN  */
  YYSYMBOL_OR_ASSIGN = 16,                 /* OR_ASSIGN  */
  YYSYMBOL_TYPEDEF_NAME = 17,              /* TYPEDEF_NAME  */
  YYSYMBOL_TYPEDEF = 18,                   /* TYPEDEF  */
  YYSYMBOL_EXTERN = 19,                    /* EXTERN  */
  YYSYMBOL_STATIC = 20,                    /* STATIC  */
  YYSYMBOL_AUTO = 21,                      /* AUTO  */
  YYSYMBOL_REGISTER = 22,                  /* REGISTER  */
  YYSYMBOL_INLINE = 23,                    /* INLINE  */
  YYSYMBOL_CONST = 24,                     /* CONST  */
  YYSYMBOL_RESTRICT = 25,                  /* RESTRICT  */
  YYSYMBOL_VOLATILE = 26,                  /* VOLATILE  */
  YYSYMBOL_CHAR = 27,                      /* CHAR  */
  YYSYMBOL_SHORT = 28,                     /* SHORT  */
  YYSYMBOL_LONG = 29,                      /* LONG  */
  YYSYMBOL_SIGNED = 30,                    /* SIGNED  */
  YYSYMBOL_UNSIGNED = 31,                  /* UNSIGNED  */
  YYSYMBOL_VOID = 32,                      /* VOID  */
  YYSYMBOL_COMPLEX = 33,                   /* COMPLEX  */
  YYSYMBOL_IMAGINARY = 34,                 /* IMAGINARY  */
  YYSYMBOL_STRUCT = 35,                    /* STRUCT  */
  YYSYMBOL_UNION = 36,                     /* UNION  */
  YYSYMBOL_ENUM = 37,                      /* ENUM  */
  YYSYMBOL_ELLIPSIS = 38,                  /* ELLIPSIS  */
  YYSYMBOL_CASE = 39,                      /* CASE  */
  YYSYMBOL_DEFAULT = 40,                   /* DEFAULT  */
  YYSYMBOL_IF = 41,                        /* IF  */
  YYSYMBOL_ELSE = 42,                      /* ELSE  */
  YYSYMBOL_SWITCH = 43,                    /* SWITCH  */
  YYSYMBOL_WHILE = 44,                     /* WHILE  */
  YYSYMBOL_DO = 45,                        /* DO  */
  YYSYMBOL_FOR = 46,                       /* FOR  */
  YYSYMBOL_GOTO = 47,                      /* GOTO  */
  YYSYMBOL_CONTINUE = 48,                  /* CONTINUE  */
  YYSYMBOL_BREAK = 49,                     /* BREAK  */
  YYSYMBOL_RETURN = 50,                    /* RETURN  */
  YYSYMBOL_ALIGNAS = 51,                   /* ALIGNAS  */
  YYSYMBOL_ALIGNOF = 52,                   /* ALIGNOF  */
  YYSYMBOL_ATOMIC = 53,                    /* ATOMIC  */
  YYSYMBOL_NORETURN = 54,                  /* NORETURN  */
  YYSYMBOL_STATIC_ASSERT = 55,             /* STATIC_ASSERT  */
  YYSYMBOL_THREAD_LOCAL = 56,              /* THREAD_LOCAL  */
  YYSYMBOL_INT = 57,                       /* INT  */
  YYSYMBOL_FLOAT = 58,                     /* FLOAT  */
  YYSYMBOL_IDENTIFIER = 59,                /* IDENTIFIER  */
  YYSYMBOL_STRING_LITERAL = 60,            /* STRING_LITERAL  */
  YYSYMBOL_ENUMERATION_CONSTANT = 61,      /* ENUMERATION_CONSTANT  */
  YYSYMBOL_FUNC_NAME = 62,                 /* FUNC_NAME  */
  YYSYMBOL_GENERIC = 63,                   /* GENERIC  */
  YYSYMBOL_INT_CONST = 64,                 /* INT_CONST  */
  YYSYMBOL_I_CONSTANT = 65,                /* I_CONSTANT  */
  YYSYMBOL_FLOAT_CONST = 66,               /* FLOAT_CONST  */
  YYSYMBOL_F_CONSTANT = 67,                /* F_CONSTANT  */
  YYSYMBOL_DOUBLE_CONST = 68,              /* DOUBLE_CONST  */
  YYSYMBOL_DOUBLE = 69,                    /* DOUBLE  */
  YYSYMBOL_BOOL = 70,                      /* BOOL  */
  YYSYMBOL_LE_OP = 71,                     /* LE_OP  */
  YYSYMBOL_GE_OP = 72,                     /* GE_OP  */
  YYSYMBOL_EQ_OP = 73,                     /* EQ_OP  */
  YYSYMBOL_NE_OP = 74,                     /* NE_OP  */
  YYSYMBOL_AND_OP = 75,                    /* AND_OP  */
  YYSYMBOL_OR_OP = 76,                     /* OR_OP  */
  YYSYMBOL_LEFT_OP = 77,                   /* LEFT_OP  */
  YYSYMBOL_RIGHT_OP = 78,                  /* RIGHT_OP  */
  YYSYMBOL_79_ = 79,                       /* '('  */
  YYSYMBOL_80_ = 80,                       /* ')'  */
  YYSYMBOL_81_ = 81,                       /* ','  */
  YYSYMBOL_82_ = 82,                       /* ':'  */
  YYSYMBOL_83_ = 83,                       /* '['  */
  YYSYMBOL_84_ = 84,                       /* ']'  */
  YYSYMBOL_85_ = 85,                       /* '.'  */
  YYSYMBOL_86_ = 86,                       /* '{'  */
  YYSYMBOL_87_ = 87,                       /* '}'  */
  YYSYMBOL_88_ = 88,                       /* '&'  */
  YYSYMBOL_89_ = 89,                       /* '*'  */
  YYSYMBOL_90_ = 90,                       /* '+'  */
  YYSYMBOL_91_ = 91,                       /* '-'  */
  YYSYMBOL_92_ = 92,                       /* '~'  */
  YYSYMBOL_93_ = 93,                       /* '!'  */
  YYSYMBOL_94_ = 94,                       /* '/'  */
  YYSYMBOL_95_ = 95,                       /* '%'  */
  YYSYMBOL_96_ = 96,                       /* '<'  */
  YYSYMBOL_97_ = 97,                       /* '>'  */
  YYSYMBOL_98_ = 98,                       /* '^'  */
  YYSYMBOL_99_ = 99,                       /* '|'  */
  YYSYMBOL_100_ = 100,                     /* '?'  */
  YYSYMBOL_101_ = 101,                     /* '='  */
  YYSYMBOL_102_ = 102,                     /* ';'  */
  YYSYMBOL_YYACCEPT = 103,                 /* $accept  */
  YYSYMBOL_primary_expression = 104,       /* primary_expression  */
  YYSYMBOL_constant = 105,                 /* constant  */
  YYSYMBOL_enumeration_constant = 106,     /* enumeration_constant  */
  YYSYMBOL_string = 107,                   /* string  */
  YYSYMBOL_generic_selection = 108,        /* generic_selection  */
  YYSYMBOL_generic_assoc_list = 109,       /* generic_assoc_list  */
  YYSYMBOL_generic_association = 110,      /* generic_association  */
  YYSYMBOL_postfix_expression = 111,       /* postfix_expression  */
  YYSYMBOL_argument_expression_list = 112, /* argument_expression_list  */
  YYSYMBOL_unary_expression = 113,         /* unary_expression  */
  YYSYMBOL_unary_operator = 114,           /* unary_operator  */
  YYSYMBOL_cast_expression = 115,          /* cast_expression  */
  YYSYMBOL_multiplicative_expression = 116, /* multiplicative_expression  */
  YYSYMBOL_additive_expression = 117,      /* additive_expression  */
  YYSYMBOL_shift_expression = 118,         /* shift_expression  */
  YYSYMBOL_relational_expression = 119,    /* relational_expression  */
  YYSYMBOL_equality_expression = 120,      /* equality_expression  */
  YYSYMBOL_and_expression = 121,           /* and_expression  */
  YYSYMBOL_exclusive_or_expression = 122,  /* exclusive_or_expression  */
  YYSYMBOL_inclusive_or_expression = 123,  /* inclusive_or_expression  */
  YYSYMBOL_logical_and_expression = 124,   /* logical_and_expression  */
  YYSYMBOL_logical_or_expression = 125,    /* logical_or_expression  */
  YYSYMBOL_conditional_expression = 126,   /* conditional_expression  */
  YYSYMBOL_assignment_expression = 127,    /* assignment_expression  */
  YYSYMBOL_assignment_operator = 128,      /* assignment_operator  */
  YYSYMBOL_expression = 129,               /* expression  */
  YYSYMBOL_constant_expression = 130,      /* constant_expression  */
  YYSYMBOL_declaration = 131,              /* declaration  */
  YYSYMBOL_declaration_specifiers = 132,   /* declaration_specifiers  */
  YYSYMBOL_init_declarator_list = 133,     /* init_declarator_list  */
  YYSYMBOL_init_declarator = 134,          /* init_declarator  */
  YYSYMBOL_storage_class_specifier = 135,  /* storage_class_specifier  */
  YYSYMBOL_type_specifier = 136,           /* type_specifier  */
  YYSYMBOL_struct_or_union_specifier = 137, /* struct_or_union_specifier  */
  YYSYMBOL_struct_or_union = 138,          /* struct_or_union  */
  YYSYMBOL_struct_declaration_list = 139,  /* struct_declaration_list  */
  YYSYMBOL_struct_declaration = 140,       /* struct_declaration  */
  YYSYMBOL_specifier_qualifier_list = 141, /* specifier_qualifier_list  */
  YYSYMBOL_struct_declarator_list = 142,   /* struct_declarator_list  */
  YYSYMBOL_struct_declarator = 143,        /* struct_declarator  */
  YYSYMBOL_enum_specifier = 144,           /* enum_specifier  */
  YYSYMBOL_enumerator_list = 145,          /* enumerator_list  */
  YYSYMBOL_enumerator = 146,               /* enumerator  */
  YYSYMBOL_atomic_type_specifier = 147,    /* atomic_type_specifier  */
  YYSYMBOL_type_qualifier = 148,           /* type_qualifier  */
  YYSYMBOL_function_specifier = 149,       /* function_specifier  */
  YYSYMBOL_alignment_specifier = 150,      /* alignment_specifier  */
  YYSYMBOL_declarator = 151,               /* declarator  */
  YYSYMBOL_direct_declarator = 152,        /* direct_declarator  */
  YYSYMBOL_pointer = 153,                  /* pointer  */
  YYSYMBOL_type_qualifier_list = 154,      /* type_qualifier_list  */
  YYSYMBOL_parameter_type_list = 155,      /* parameter_type_list  */
  YYSYMBOL_parameter_list = 156,           /* parameter_list  */
  YYSYMBOL_parameter_declaration = 157,    /* parameter_declaration  */
  YYSYMBOL_identifier_list = 158,          /* identifier_list  */
  YYSYMBOL_type_name = 159,                /* type_name  */
  YYSYMBOL_abstract_declarator = 160,      /* abstract_declarator  */
  YYSYMBOL_direct_abstract_declarator = 161, /* direct_abstract_declarator  */
  YYSYMBOL_initializer = 162,              /* initializer  */
  YYSYMBOL_initializer_list = 163,         /* initializer_list  */
  YYSYMBOL_static_assert_declaration = 164, /* static_assert_declaration  */
  YYSYMBOL_statement = 165,                /* statement  */
  YYSYMBOL_labeled_statement = 166,        /* labeled_statement  */
  YYSYMBOL_compound_statement = 167,       /* compound_statement  */
  YYSYMBOL_block_item_list = 168,          /* block_item_list  */
  YYSYMBOL_block_item = 169,               /* block_item  */
  YYSYMBOL_expression_statement = 170,     /* expression_statement  */
  YYSYMBOL_selection_statement = 171,      /* selection_statement  */
  YYSYMBOL_iteration_statement = 172,      /* iteration_statement  */
  YYSYMBOL_jump_statement = 173,           /* jump_statement  */
  YYSYMBOL_translation_unit = 174,         /* translation_unit  */
  YYSYMBOL_external_declaration = 175,     /* external_declaration  */
  YYSYMBOL_function_definition = 176,      /* function_definition  */
  YYSYMBOL_declaration_list = 177          /* declaration_list  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  67
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   2995

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  103
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  75
/* YYNRULES -- Number of rules.  */
#define YYNRULES  275
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  487

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   333


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    93,     2,     2,     2,    95,    88,     2,
      79,    80,    89,    90,    81,    91,    85,    94,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    82,   102,
      96,   101,    97,   100,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    83,     2,    84,    98,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    86,    99,    87,    92,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    90,    90,    91,    92,    93,    94,    98,    99,   100,
     104,   108,   109,   113,   117,   118,   122,   123,   127,   128,
     129,   130,   131,   132,   133,   134,   135,   136,   140,   141,
     145,   146,   147,   148,   149,   150,   151,   155,   156,   157,
     158,   159,   160,   164,   165,   169,   170,   171,   172,   176,
     177,   178,   182,   183,   184,   188,   189,   190,   191,   192,
     196,   197,   198,   202,   203,   207,   208,   212,   213,   217,
     218,   222,   223,   227,   228,   232,   233,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   251,   252,
     256,   260,   261,   262,   266,   267,   268,   269,   270,   271,
     272,   273,   274,   275,   279,   280,   284,   285,   289,   290,
     291,   292,   293,   294,   298,   301,   304,   307,   310,   313,
     316,   319,   322,   325,   328,   331,   334,   335,   336,   337,
     341,   342,   343,   347,   348,   352,   353,   357,   358,   359,
     363,   364,   365,   366,   370,   371,   375,   376,   377,   381,
     382,   383,   384,   385,   389,   390,   394,   395,   399,   403,
     404,   405,   406,   410,   411,   415,   416,   420,   421,   425,
     426,   427,   428,   429,   430,   431,   432,   433,   434,   435,
     436,   437,   438,   442,   443,   444,   445,   449,   450,   455,
     456,   460,   461,   465,   466,   467,   471,   472,   476,   477,
     481,   482,   483,   487,   488,   489,   490,   491,   492,   493,
     494,   495,   496,   497,   498,   499,   500,   501,   502,   503,
     504,   505,   506,   507,   511,   512,   513,   518,   538,   542,
     543,   544,   545,   546,   547,   551,   552,   553,   557,   558,
     562,   563,   567,   568,   572,   573,   577,   578,   579,   580,
     581,   582,   586,   587,   588,   589,   590,   591,   592,   593,
     594,   595,   596,   600,   601,   602,   603,   604,   608,   613,
     617,   618,   622,   623,   627,   628
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "SIZEOF", "PTR_OP",
  "INC_OP", "DEC_OP", "MUL_ASSIGN", "DIV_ASSIGN", "MOD_ASSIGN",
  "ADD_ASSIGN", "SUB_ASSIGN", "LEFT_ASSIGN", "RIGHT_ASSIGN", "AND_ASSIGN",
  "XOR_ASSIGN", "OR_ASSIGN", "TYPEDEF_NAME", "TYPEDEF", "EXTERN", "STATIC",
  "AUTO", "REGISTER", "INLINE", "CONST", "RESTRICT", "VOLATILE", "CHAR",
  "SHORT", "LONG", "SIGNED", "UNSIGNED", "VOID", "COMPLEX", "IMAGINARY",
  "STRUCT", "UNION", "ENUM", "ELLIPSIS", "CASE", "DEFAULT", "IF", "ELSE",
  "SWITCH", "WHILE", "DO", "FOR", "GOTO", "CONTINUE", "BREAK", "RETURN",
  "ALIGNAS", "ALIGNOF", "ATOMIC", "NORETURN", "STATIC_ASSERT",
  "THREAD_LOCAL", "INT", "FLOAT", "IDENTIFIER", "STRING_LITERAL",
  "ENUMERATION_CONSTANT", "FUNC_NAME", "GENERIC", "INT_CONST",
  "I_CONSTANT", "FLOAT_CONST", "F_CONSTANT", "DOUBLE_CONST", "DOUBLE",
  "BOOL", "LE_OP", "GE_OP", "EQ_OP", "NE_OP", "AND_OP", "OR_OP", "LEFT_OP",
  "RIGHT_OP", "'('", "')'", "','", "':'", "'['", "']'", "'.'", "'{'",
  "'}'", "'&'", "'*'", "'+'", "'-'", "'~'", "'!'", "'/'", "'%'", "'<'",
  "'>'", "'^'", "'|'", "'?'", "'='", "';'", "$accept",
  "primary_expression", "constant", "enumeration_constant", "string",
  "generic_selection", "generic_assoc_list", "generic_association",
  "postfix_expression", "argument_expression_list", "unary_expression",
  "unary_operator", "cast_expression", "multiplicative_expression",
  "additive_expression", "shift_expression", "relational_expression",
  "equality_expression", "and_expression", "exclusive_or_expression",
  "inclusive_or_expression", "logical_and_expression",
  "logical_or_expression", "conditional_expression",
  "assignment_expression", "assignment_operator", "expression",
  "constant_expression", "declaration", "declaration_specifiers",
  "init_declarator_list", "init_declarator", "storage_class_specifier",
  "type_specifier", "struct_or_union_specifier", "struct_or_union",
  "struct_declaration_list", "struct_declaration",
  "specifier_qualifier_list", "struct_declarator_list",
  "struct_declarator", "enum_specifier", "enumerator_list", "enumerator",
  "atomic_type_specifier", "type_qualifier", "function_specifier",
  "alignment_specifier", "declarator", "direct_declarator", "pointer",
  "type_qualifier_list", "parameter_type_list", "parameter_list",
  "parameter_declaration", "identifier_list", "type_name",
  "abstract_declarator", "direct_abstract_declarator", "initializer",
  "initializer_list", "static_assert_declaration", "statement",
  "labeled_statement", "compound_statement", "block_item_list",
  "block_item", "expression_statement", "selection_statement",
  "iteration_statement", "jump_statement", "translation_unit",
  "external_declaration", "function_definition", "declaration_list", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-173)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-144)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     610,  -173,  -173,  -173,  -173,  -173,  -173,  -173,  -173,  -173,
    -173,  -173,  -173,  -173,  -173,  -173,  -173,  -173,  -173,  -173,
    -173,   -56,   -35,   -11,  -173,    37,  -173,  -173,  -173,  -173,
    -173,  -173,    52,  2784,  2784,  -173,   -26,  -173,  -173,  2784,
    2784,  2784,  -173,  2233,  -173,  -173,     5,   -27,  1138,  2925,
    1750,  -173,    -1,   113,  -173,    77,  -173,  2002,    34,    43,
    -173,  -173,    38,  2831,  -173,  -173,  -173,  -173,  -173,   -27,
    -173,    25,   -47,  -173,  1785,  1820,  1820,    54,  -173,  -173,
    -173,  -173,    65,  -173,  -173,  1138,  -173,  -173,  -173,  -173,
    -173,  -173,  -173,  -173,  -173,  -173,    44,  -173,  1750,  -173,
     -53,   110,   139,   136,     3,    64,    59,    56,    92,   -37,
    -173,   107,  2925,   -54,  2925,   129,   142,   143,   170,  -173,
    -173,  -173,   113,    -1,  -173,   524,  1540,  -173,    52,  -173,
    2398,  2602,  1213,    34,  2831,  2280,  -173,    71,  -173,   -14,
    1750,   -33,  -173,  1138,  -173,  1138,  -173,  -173,  2925,  1750,
     287,  -173,  -173,   150,   174,   202,  -173,  -173,  1575,  1750,
     204,  -173,  1750,  1750,  1750,  1750,  1750,  1750,  1750,  1750,
    1750,  1750,  1750,  1750,  1750,  1750,  1750,  1750,  1750,  1750,
    1750,  -173,  -173,  2160,  1257,   102,  -173,   132,  -173,  -173,
    -173,   205,  -173,  -173,  -173,  -173,   175,  1750,   185,  1855,
    1890,  1925,   919,   760,   219,   187,   189,  1011,   222,  -173,
    -173,    78,  -173,  -173,  -173,  -173,   669,  -173,  -173,  -173,
    -173,  -173,  1540,  -173,  -173,  -173,  -173,  -173,  -173,   115,
     207,   229,  -173,   154,  1498,  -173,   231,   232,  1308,  2327,
    -173,  -173,  1750,  -173,    80,  -173,   237,   -31,  -173,  -173,
    -173,  -173,   233,   244,   246,   248,  -173,  -173,  -173,  -173,
    -173,  -173,  -173,  -173,  -173,  -173,  -173,  1750,  -173,  1750,
    1610,  -173,  -173,   157,  -173,   137,  -173,  -173,  -173,  -173,
     -53,   -53,   110,   110,   139,   139,   139,   139,   136,   136,
       3,    64,    59,    56,    92,   158,  -173,   247,   251,  1498,
    -173,   249,   250,  1352,   132,  2666,  1403,   255,   258,   919,
    1138,    82,  1138,    82,  1138,    82,   293,   851,  1059,  1059,
     239,  -173,  -173,  -173,    90,   919,  -173,  -173,  -173,  -173,
     -12,  2087,  -173,     6,  -173,  -173,  2730,  -173,   283,   260,
    1498,  -173,  -173,  1750,  -173,   263,   265,  -173,  -173,    83,
    -173,  1750,  -173,   264,   264,  -173,  2878,  -173,  -173,  1540,
    -173,  -173,  1750,  -173,  1750,  -173,  -173,   269,  1498,  -173,
    -173,  1750,  -173,   271,  -173,   277,  1498,  -173,   274,   275,
    1447,   259,   919,  -173,   161,   318,   163,  -173,   166,  -173,
     285,    68,  1059,  2468,  2535,  1059,  1645,   967,  -173,  -173,
    -173,   278,  -173,  -173,  -173,  -173,  -173,   282,   289,  -173,
    -173,  -173,  -173,   292,   168,  -173,   294,    27,  -173,  -173,
    -173,   291,   296,  -173,  -173,   297,  1498,  -173,  -173,  1750,
    -173,   298,  -173,  -173,   919,   281,   919,   919,  1750,  1680,
    1715,    82,  -173,  -173,   281,  -173,  -173,  -173,  1750,  -173,
    2878,  1750,   284,  -173,  -173,  -173,  -173,   299,   300,  -173,
     327,  -173,  -173,  -173,   172,   919,   176,   919,   179,  -173,
    -173,  -173,  -173,  -173,  -173,  -173,  -173,   919,   290,  -173,
     919,  -173,   919,  -173,  -173,  -173,  -173
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
       0,   129,   108,   109,   110,   112,   113,   163,   159,   160,
     161,   115,   116,   118,   121,   122,   114,   124,   125,   133,
     134,     0,     0,   162,   164,     0,   111,   117,   119,   120,
     123,   271,     0,    95,    97,   127,     0,   128,   126,    99,
     101,   103,    93,     0,   268,   270,   153,     0,     0,     0,
       0,   169,     0,   186,    91,     0,   104,   107,   168,     0,
      94,    96,   132,     0,    98,   100,   102,     1,   269,     0,
      10,   157,     0,   154,     0,     0,     0,     0,     2,    11,
       9,    12,     0,     7,     8,     0,    37,    38,    39,    40,
      41,    42,    18,     3,     4,     6,    30,    43,     0,    45,
      49,    52,    55,    60,    63,    65,    67,    69,    71,    73,
      90,     0,   141,   199,   143,     0,     0,     0,     0,   162,
     187,   185,   184,     0,    92,     0,     0,   274,     0,   273,
       0,     0,     0,   167,     0,     0,   135,     0,   139,     0,
       0,     0,   149,     0,    34,     0,    31,    32,     0,     0,
      43,    75,    88,     0,     0,     0,    24,    25,     0,     0,
       0,    33,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   166,   140,     0,     0,   201,   198,   202,   142,   165,
     158,     0,   170,   188,   183,   105,   107,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     2,   238,
     244,     0,   242,   243,   229,   230,     0,   240,   231,   232,
     233,   234,     0,   226,   106,   275,   272,   196,   181,   195,
       0,   190,   191,     0,     0,   171,    38,     0,     0,     0,
     130,   136,     0,   137,     0,   144,   148,     0,   151,   156,
     150,   155,     0,     0,     0,     0,    78,    79,    80,    81,
      82,    83,    84,    85,    86,    87,    77,     0,     5,     0,
       0,    23,    20,     0,    28,     0,    22,    46,    47,    48,
      50,    51,    53,    54,    58,    59,    56,    57,    61,    62,
      64,    66,    68,    70,    72,     0,   220,     0,     0,     0,
     204,    38,     0,     0,   200,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   264,   265,   266,     0,     0,   245,   239,   241,   227,
       0,     0,   193,   201,   194,   180,     0,   182,     0,     0,
       0,   172,   179,     0,   178,    38,     0,   131,   146,     0,
     138,     0,   152,    35,     0,    36,     0,    76,    89,     0,
      44,    21,     0,    19,     0,   221,   203,     0,     0,   205,
     211,     0,   210,     0,   222,     0,     0,   212,    38,     0,
       0,     0,     0,   237,     0,   249,     0,   251,     0,   253,
       0,     0,     0,    97,    99,     0,     0,     0,   263,   267,
     235,     0,   224,   189,   192,   197,   174,     0,     0,   175,
     177,   145,   147,     0,     0,    14,     0,     0,    29,    74,
     207,     0,     0,   209,   223,     0,     0,   213,   219,     0,
     218,     0,   228,   236,     5,     0,     5,     5,     0,     0,
       0,     0,   258,   255,     0,   225,   173,   176,     0,    13,
       0,     0,     0,    26,   206,   208,   215,     0,     0,   216,
     247,   248,   250,   252,     0,     0,     0,     0,     0,   257,
     256,    17,    15,    16,    27,   214,   217,     0,     0,   261,
       0,   259,     0,   246,   254,   262,   260
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -173,  -173,  -173,  -173,  -173,  -173,  -173,   -73,  -173,  -173,
     320,  -173,   -81,   108,   117,    57,   138,   210,   211,   212,
     213,   218,  -173,   -28,    87,  -173,   -24,   -46,   -10,    12,
    -173,   276,  -173,   -42,  -173,  -173,   266,  -111,   -55,  -173,
      49,  -173,   334,  -122,  -173,   -48,  -173,  -173,   -19,   -50,
     -51,   -94,  -117,  -173,    73,  -173,   -38,   -95,  -169,   295,
      45,   -36,    -3,  -173,   -34,  -173,   195,  -172,  -173,  -173,
    -173,  -173,   370,  -173,  -173
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,    92,    93,    71,    94,    95,   414,   415,    96,   273,
     150,    98,    99,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   151,   152,   267,   211,   111,    31,   128,
      55,    56,    33,    34,    35,    36,   135,   136,   113,   244,
     245,    37,    72,    73,    38,    39,    40,    41,   118,    58,
      59,   122,   297,   231,   232,   233,   154,   298,   187,   329,
     330,    42,   213,   214,   215,   216,   217,   218,   219,   220,
     221,    43,    44,    45,   130
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
     114,   114,   121,    46,   117,   120,   112,   112,   137,   133,
     115,   116,    32,    57,   230,   114,   304,   161,   186,   251,
     110,   112,   110,   129,   241,   183,    70,   138,    70,   184,
      47,   319,    70,    62,   141,    53,   162,   114,   238,   179,
     142,   163,   164,   112,    48,    60,    61,   127,   155,   156,
     157,    64,    65,    66,   250,    32,   352,   182,    51,   188,
      63,   153,   185,   180,   114,    51,   114,   247,    49,   401,
     112,   194,   112,   248,   193,   402,   173,   174,    52,   137,
     137,   277,   278,   279,   120,   331,   114,   114,    53,   184,
     303,    69,   112,   112,   249,   114,   226,   114,   138,   138,
     114,   112,    51,   112,   196,   252,   112,   253,   452,   196,
     254,    51,   110,   131,   453,   212,    50,   132,   246,   153,
     225,   153,    52,   158,   134,   251,   140,   159,   241,   160,
      51,    52,   185,   148,   334,   275,   120,     8,     9,    10,
     340,    53,    51,   229,   149,   395,   396,   397,   268,   269,
      52,   308,   175,   242,    54,   177,   295,   176,   123,   269,
      53,   349,    52,   269,   304,   242,   119,   178,   125,   110,
     326,   269,    53,   243,    51,   311,   313,   315,   333,   124,
     326,   183,   350,   324,   137,   184,   120,   181,   375,   360,
     193,   114,   399,   318,   331,   229,   348,   112,   184,   316,
     165,   166,    53,   138,    53,   368,   212,   169,   170,   189,
     332,   305,   380,   223,   110,   306,   167,   168,   269,   237,
     439,   363,   190,   440,   191,   444,   284,   285,   286,   287,
     268,   269,   171,   172,   337,   338,   255,   361,   362,   269,
     364,   434,   269,   436,   269,   274,   437,   269,   449,   450,
     192,   120,   478,   269,   270,   193,   480,   269,   120,   482,
     269,   271,   114,   276,   114,   307,   114,   309,   112,   394,
     112,   302,   112,   280,   281,   393,   126,   385,   320,   387,
     333,   389,   426,   133,   282,   283,   384,   335,   386,   321,
     388,   322,   193,   391,   256,   257,   258,   259,   260,   261,
     262,   263,   264,   265,   325,   412,   383,   392,   114,   223,
     336,   288,   289,   353,   112,   341,   342,   229,   416,   351,
     193,   339,   400,   110,   354,   346,   355,   365,   120,   356,
     246,   366,   193,   369,   370,   381,   419,   390,   182,   188,
     382,   398,   405,   229,   406,   394,   394,   409,   229,   410,
     359,   393,   393,   420,   357,   423,   358,   424,   427,   428,
     435,   432,   442,   443,   438,   445,   446,   125,    97,   477,
      97,   474,   441,   447,   448,   454,   451,   472,   193,   433,
     455,   456,   459,   475,   476,   290,   367,   291,   266,   292,
     373,   293,   484,   379,   144,   146,   147,   294,   411,   195,
     239,   461,   114,   139,   417,    61,    64,   469,   112,   404,
     470,   328,   416,    68,   464,   466,   468,     0,    97,     0,
       0,   224,     0,     0,     0,     0,     0,   407,     0,     0,
     408,   460,     0,   462,   463,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   223,     0,     0,   418,
       0,     0,     0,     0,     0,   421,     0,     0,   422,     0,
      97,     0,   479,   425,   481,     0,     0,   431,     0,     0,
       0,     0,     0,     0,   483,     0,     0,   485,     0,   486,
       0,     0,    97,    97,    97,    97,    97,    97,    97,    97,
      97,    97,    97,    97,    97,    97,    97,    97,    97,    97,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   457,     0,     0,   458,    97,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    74,     0,    75,
      76,     0,     0,     0,     0,   471,     0,     0,   473,     0,
       0,     1,     2,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,    21,    97,   197,   198,   199,     0,   200,   201,   202,
     203,   204,   205,   206,   207,    22,    77,    23,    24,    25,
      26,    27,    28,   208,    79,    80,    81,    82,     0,    83,
      97,    84,     0,    29,    30,     0,     0,     0,     0,     0,
       0,     0,     0,    85,     0,     0,     0,     0,     0,     0,
     125,   209,    86,    87,    88,    89,    90,    91,     0,     0,
       0,     0,     0,     0,     0,     0,   210,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    21,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    22,     0,    23,    24,    25,    26,    27,    28,     0,
       0,    97,    74,     0,    75,    76,     0,     0,     0,    29,
      30,     0,     0,     0,    97,     0,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,     0,   197,   198,
     199,     0,   200,   201,   202,   203,   204,   205,   206,   207,
      22,    77,    23,    24,    25,    26,    27,    28,   208,    79,
      80,    81,    82,     0,    83,     0,    84,     0,    29,    30,
       0,     0,     0,     0,     0,     0,     0,     0,    85,     0,
       0,     0,     0,     0,     0,   125,   327,    86,    87,    88,
      89,    90,    91,    74,     0,    75,    76,     0,     0,     0,
       0,   210,     0,     0,     0,     0,     0,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    21,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    22,    77,    23,    24,    25,    26,    27,    28,    78,
      79,    80,    81,    82,     0,    83,     0,    84,     0,    29,
      30,     0,     0,     0,     0,     0,     0,     0,     0,   317,
       0,     0,     0,     0,     0,     0,     0,     0,    86,    87,
      88,    89,    90,    91,    74,     0,    75,    76,     0,     0,
       0,     0,   210,     0,     0,     0,     0,     0,     1,     2,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,    21,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    22,    77,    23,    24,    25,    26,    27,    28,
      78,    79,    80,    81,    82,     0,    83,     0,    84,     0,
      29,    30,    74,     0,    75,    76,     0,     0,     0,     0,
      85,     0,     0,     0,     0,     0,     0,     0,     0,    86,
      87,    88,    89,    90,    91,     0,     0,     0,     0,     0,
       0,     0,     0,   210,     0,     0,     0,     0,   197,   198,
     199,     0,   200,   201,   202,   203,   204,   205,   206,   207,
      74,    77,    75,    76,     0,     0,     0,     0,   208,    79,
      80,    81,    82,     0,    83,     0,    84,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    85,     0,
       0,     0,     0,     0,     0,   125,     0,    86,    87,    88,
      89,    90,    91,     0,    74,     0,    75,    76,     0,    77,
       0,   210,     0,     0,     0,     0,    78,    79,    80,    81,
      82,     0,    83,     0,    84,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    85,     0,     0,     0,
       0,     0,     0,   125,     0,    86,    87,    88,    89,    90,
      91,     0,    74,    77,    75,    76,     0,     0,     0,   210,
      78,    79,    80,    81,    82,     0,    83,     0,    84,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      85,     0,     0,     0,     0,     0,     0,     0,     0,    86,
      87,    88,    89,    90,    91,     0,     0,     0,     0,     0,
       0,    77,     0,   323,     0,     0,     0,     0,    78,    79,
      80,    81,    82,     0,    83,     0,    84,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    85,     0,
       0,    74,     0,    75,    76,     0,     0,    86,    87,    88,
      89,    90,    91,     0,     0,     1,     0,     0,     0,     0,
       0,   210,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,    21,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      77,    23,     0,     0,     0,    27,    28,    78,    79,    80,
      81,    82,     0,    83,     0,    84,     0,    29,    30,     0,
       0,     0,     0,     0,     0,     0,    74,    85,    75,    76,
       0,     0,     0,     0,     0,     0,    86,    87,    88,    89,
      90,    91,     0,   234,     0,     0,     0,     8,     9,    10,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      74,     0,    75,    76,     0,    77,   119,     0,     0,     0,
       0,     0,    78,    79,    80,    81,    82,   299,    83,     0,
      84,     8,     9,    10,     0,     0,     0,     0,     0,     0,
       0,     0,    85,     0,     0,     0,     0,   235,     0,     0,
       0,    86,   236,    88,    89,    90,    91,     0,     0,    77,
     119,    74,     0,    75,    76,     0,    78,    79,    80,    81,
      82,     0,    83,     0,    84,     0,     0,     0,   343,     0,
       0,     0,     8,     9,    10,     0,    85,     0,     0,     0,
       0,   300,     0,     0,     0,    86,   301,    88,    89,    90,
      91,     0,     0,     0,     0,    74,     0,    75,    76,     0,
      77,   119,     0,     0,     0,     0,     0,    78,    79,    80,
      81,    82,   371,    83,     0,    84,     8,     9,    10,     0,
       0,     0,     0,     0,     0,     0,     0,    85,     0,     0,
       0,     0,   344,     0,     0,     0,    86,   345,    88,    89,
      90,    91,     0,     0,    77,   119,    74,     0,    75,    76,
       0,    78,    79,    80,    81,    82,     0,    83,     0,    84,
       0,     0,     0,   376,     0,     0,     0,     8,     9,    10,
       0,    85,     0,     0,     0,     0,   372,     0,     0,     0,
      86,    87,    88,    89,    90,    91,     0,     0,     0,     0,
      74,     0,    75,    76,     0,    77,   119,     0,     0,     0,
       0,     0,    78,    79,    80,    81,    82,   429,    83,     0,
      84,     8,     9,    10,     0,     0,     0,     0,     0,     0,
       0,     0,    85,     0,     0,     0,     0,   377,     0,     0,
       0,    86,   378,    88,    89,    90,    91,     0,     0,    77,
     119,    74,     0,    75,    76,     0,    78,    79,    80,    81,
      82,     0,    83,     0,    84,     0,     0,     0,     0,     0,
       0,     0,     8,     9,    10,     0,    85,     0,     0,     0,
       0,   430,     0,     0,     0,    86,    87,    88,    89,    90,
      91,     0,     0,    74,     0,    75,    76,     0,     0,     0,
      77,   119,     0,     0,     0,     0,     0,    78,    79,    80,
      81,    82,     0,    83,     0,    84,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    85,    74,     0,
      75,    76,     0,     0,     0,     0,    86,    87,    88,    89,
      90,    91,    77,     0,     0,     0,     0,     0,     0,    78,
      79,    80,    81,    82,     0,    83,     0,    84,     0,     0,
       0,     0,     0,    74,     0,    75,    76,     0,     0,    85,
       0,     0,     0,     0,     0,     0,   222,    77,    86,    87,
      88,    89,    90,    91,    78,    79,    80,    81,    82,     0,
      83,     0,    84,     0,     0,     0,     0,     0,    74,     0,
      75,    76,     0,     0,    85,   272,     0,     0,     0,     0,
       0,     0,    77,    86,    87,    88,    89,    90,    91,    78,
      79,    80,    81,    82,     0,    83,     0,    84,     0,     0,
       0,     0,     0,    74,     0,    75,    76,     0,     0,    85,
       0,     0,     0,     0,     0,     0,   359,    77,    86,    87,
      88,    89,    90,    91,    78,    79,    80,    81,    82,     0,
      83,     0,    84,     0,     0,     0,     0,     0,    74,     0,
      75,    76,     0,     0,    85,     0,     0,     0,     0,     0,
       0,   125,    77,    86,    87,    88,    89,    90,    91,    78,
      79,    80,    81,    82,     0,    83,     0,    84,     0,     0,
       0,     0,     0,    74,     0,    75,    76,     0,     0,    85,
     465,     0,     0,     0,     0,     0,     0,    77,    86,    87,
      88,    89,    90,    91,    78,    79,    80,    81,    82,     0,
      83,     0,    84,     0,     0,     0,     0,     0,    74,     0,
      75,    76,     0,     0,    85,   467,     0,     0,     0,     0,
       0,     0,    77,    86,    87,    88,    89,    90,    91,    78,
      79,    80,    81,    82,     0,    83,     0,    84,     0,     0,
       0,     0,     0,    74,     0,    75,    76,     0,     0,    85,
       0,     0,     0,     0,     0,     0,     0,    77,    86,    87,
      88,    89,    90,    91,    78,    79,    80,    81,    82,     0,
      83,     0,    84,     0,     0,     0,     0,     0,    74,     0,
      75,    76,     0,     0,   143,     0,     0,     0,     0,     0,
       0,     0,    77,    86,    87,    88,    89,    90,    91,    78,
      79,    80,    81,    82,     0,    83,     0,    84,     0,     0,
       0,     0,     0,    74,     0,    75,    76,     0,     0,   145,
       0,     0,     0,     0,     0,     0,     0,    77,    86,    87,
      88,    89,    90,    91,    78,    79,    80,    81,    82,     0,
      83,     0,    84,     0,     0,     0,     0,     0,    74,     0,
      75,    76,     0,     0,   310,     0,     0,     0,     0,     0,
       0,     0,    77,    86,    87,    88,    89,    90,    91,    78,
      79,    80,    81,    82,     0,    83,     0,    84,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   312,
       0,     0,     0,     0,     0,     0,     0,    77,    86,    87,
      88,    89,    90,    91,    78,    79,    80,    81,    82,     0,
      83,     0,    84,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   314,     0,     0,     0,     0,     0,
       0,     0,     0,    86,    87,    88,    89,    90,    91,     1,
       2,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,    21,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    22,     0,    23,    24,    25,    26,    27,
      28,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    29,    30,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   125,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   126,     1,     2,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,    21,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    22,     0,
      23,    24,     0,    26,    27,    28,    51,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    29,    30,     0,     0,
       0,     0,     0,     0,     0,     0,   331,   296,     0,     0,
     184,     0,     0,     0,     0,     0,    53,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    21,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    22,     0,    23,    24,     0,    26,    27,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    29,
      30,     0,     0,    67,     0,     0,     0,     0,     0,   183,
     296,     0,     0,   184,     0,     0,     0,     0,     0,    53,
       1,     2,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
      21,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    22,     0,    23,    24,    25,    26,
      27,    28,     0,     0,     0,     0,     0,     1,     0,     0,
       0,     0,    29,    30,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    21,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    23,     0,    25,     0,    27,    28,     0,
       0,     0,     0,     0,     1,     0,     0,     0,     0,    29,
      30,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,    21,     0,     0,   240,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      23,     0,    25,     0,    27,    28,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    29,    30,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   347,     1,     2,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,    21,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    22,
       0,    23,    24,    25,    26,    27,    28,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    29,    30,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   125,     1,     2,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,    21,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    22,
       0,    23,    24,     0,    26,    27,    28,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    29,    30,     0,
       0,     0,     0,     0,     0,     0,     0,     0,  -141,     0,
       0,  -141,     1,     2,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,    21,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    22,     0,    23,    24,
       0,    26,    27,    28,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    29,    30,     0,     0,     0,     0,
       0,     0,     0,     0,     0,  -143,     0,     0,  -143,     1,
       2,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,    21,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    22,     0,    23,    24,     0,    26,    27,
      28,   227,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    29,    30,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   228,     1,     2,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,    21,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    22,     0,    23,
      24,     0,    26,    27,    28,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    29,    30,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   374,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,    21,   403,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    22,     0,    23,    24,     0,    26,    27,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    29,
      30,     1,     2,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,    21,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    22,     0,    23,    24,     0,
      26,    27,    28,     0,     0,     0,     0,     0,     1,     0,
       0,     0,     0,    29,    30,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,    21,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    23,     0,    25,     0,    27,    28,
       0,     0,     0,     0,     0,     1,     0,     0,     0,     0,
      29,    30,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,    21,     0,     0,   413,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    23,     0,     0,     0,    27,    28,     0,     0,     0,
       0,     0,     1,     0,     0,     0,     0,    29,    30,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,    21,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    23,     0,
       0,     0,    27,    28,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    29,    30
};

static const yytype_int16 yycheck[] =
{
      48,    49,    53,    59,    50,    53,    48,    49,    63,    59,
      48,    49,     0,    32,   131,    63,   185,    98,   113,   141,
      48,    63,    50,    57,   135,    79,    59,    63,    59,    83,
      86,   203,    59,    59,    81,    89,    89,    85,   132,    76,
      87,    94,    95,    85,    79,    33,    34,    57,     4,     5,
       6,    39,    40,    41,    87,    43,    87,   112,    59,   114,
      86,    85,   113,   100,   112,    59,   114,    81,    79,    81,
     112,   122,   114,    87,   122,    87,    73,    74,    79,   134,
     135,   162,   163,   164,   132,    79,   134,   135,    89,    83,
     184,    86,   134,   135,   140,   143,   130,   145,   134,   135,
     148,   143,    59,   145,   123,   143,   148,   145,    81,   128,
     148,    59,   140,    79,    87,   125,    79,    83,   137,   143,
     130,   145,    79,    79,    86,   247,   101,    83,   239,    85,
      59,    79,   183,    79,   229,   159,   184,    24,    25,    26,
     234,    89,    59,   131,    79,   317,   318,   319,    80,    81,
      79,   197,    88,    82,   102,    99,   180,    98,    81,    81,
      89,    81,    79,    81,   333,    82,    53,    75,    86,   197,
     102,    81,    89,   102,    59,   199,   200,   201,   229,   102,
     102,    79,   102,   207,   239,    83,   234,    80,   305,   270,
     238,   239,   102,   203,    79,   183,   242,   239,    83,   202,
      90,    91,    89,   239,    89,   299,   216,    71,    72,    80,
     229,    79,   306,   126,   242,    83,    77,    78,    81,   132,
     392,    84,    80,   395,    81,   397,   169,   170,   171,   172,
      80,    81,    96,    97,    80,    81,   149,    80,    81,    81,
      82,    80,    81,    80,    81,   158,    80,    81,    80,    81,
      80,   299,    80,    81,    80,   303,    80,    81,   306,    80,
      81,    59,   310,    59,   312,    60,   314,    82,   310,   317,
     312,   184,   314,   165,   166,   317,   101,   311,    59,   313,
     331,   315,   376,   333,   167,   168,   310,    80,   312,   102,
     314,   102,   340,   317,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    82,   351,   309,   317,   356,   222,
      81,   173,   174,    80,   356,    84,    84,   305,   356,    82,
     368,   234,   325,   351,    80,   238,    80,    80,   376,    81,
     349,    80,   380,    84,    84,    80,   364,    44,   393,   394,
      82,   102,    59,   331,    84,   393,   394,    84,   336,    84,
      86,   393,   394,    84,   267,    84,   269,    80,    84,    84,
      42,   102,   396,   397,    79,    87,    84,    86,    48,    42,
      50,    87,   396,    84,    82,    84,    82,   450,   426,   382,
      84,    84,    84,    84,    84,   175,   299,   176,   101,   177,
     303,   178,   102,   306,    74,    75,    76,   179,   349,   123,
     134,   435,   450,    69,   359,   393,   394,   441,   450,   336,
     444,   216,   450,    43,   438,   439,   440,    -1,    98,    -1,
      -1,   126,    -1,    -1,    -1,    -1,    -1,   340,    -1,    -1,
     343,   434,    -1,   436,   437,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   359,    -1,    -1,   362,
      -1,    -1,    -1,    -1,    -1,   368,    -1,    -1,   371,    -1,
     140,    -1,   465,   376,   467,    -1,    -1,   380,    -1,    -1,
      -1,    -1,    -1,    -1,   477,    -1,    -1,   480,    -1,   482,
      -1,    -1,   162,   163,   164,   165,   166,   167,   168,   169,
     170,   171,   172,   173,   174,   175,   176,   177,   178,   179,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   426,    -1,    -1,   429,   197,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     3,    -1,     5,
       6,    -1,    -1,    -1,    -1,   448,    -1,    -1,   451,    -1,
      -1,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,   242,    39,    40,    41,    -1,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    -1,    65,
     270,    67,    -1,    69,    70,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,    -1,
      86,    87,    88,    89,    90,    91,    92,    93,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   102,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    51,    -1,    53,    54,    55,    56,    57,    58,    -1,
      -1,   351,     3,    -1,     5,     6,    -1,    -1,    -1,    69,
      70,    -1,    -1,    -1,   364,    -1,    17,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    -1,    39,    40,
      41,    -1,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    -1,    65,    -1,    67,    -1,    69,    70,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,    -1,
      -1,    -1,    -1,    -1,    -1,    86,    87,    88,    89,    90,
      91,    92,    93,     3,    -1,     5,     6,    -1,    -1,    -1,
      -1,   102,    -1,    -1,    -1,    -1,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    -1,    65,    -1,    67,    -1,    69,
      70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    88,    89,
      90,    91,    92,    93,     3,    -1,     5,     6,    -1,    -1,
      -1,    -1,   102,    -1,    -1,    -1,    -1,    -1,    17,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,    -1,    65,    -1,    67,    -1,
      69,    70,     3,    -1,     5,     6,    -1,    -1,    -1,    -1,
      79,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    88,
      89,    90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   102,    -1,    -1,    -1,    -1,    39,    40,
      41,    -1,    43,    44,    45,    46,    47,    48,    49,    50,
       3,    52,     5,     6,    -1,    -1,    -1,    -1,    59,    60,
      61,    62,    63,    -1,    65,    -1,    67,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,    -1,
      -1,    -1,    -1,    -1,    -1,    86,    -1,    88,    89,    90,
      91,    92,    93,    -1,     3,    -1,     5,     6,    -1,    52,
      -1,   102,    -1,    -1,    -1,    -1,    59,    60,    61,    62,
      63,    -1,    65,    -1,    67,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    79,    -1,    -1,    -1,
      -1,    -1,    -1,    86,    -1,    88,    89,    90,    91,    92,
      93,    -1,     3,    52,     5,     6,    -1,    -1,    -1,   102,
      59,    60,    61,    62,    63,    -1,    65,    -1,    67,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      79,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    88,
      89,    90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,
      -1,    52,    -1,   102,    -1,    -1,    -1,    -1,    59,    60,
      61,    62,    63,    -1,    65,    -1,    67,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,    -1,
      -1,     3,    -1,     5,     6,    -1,    -1,    88,    89,    90,
      91,    92,    93,    -1,    -1,    17,    -1,    -1,    -1,    -1,
      -1,   102,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      52,    53,    -1,    -1,    -1,    57,    58,    59,    60,    61,
      62,    63,    -1,    65,    -1,    67,    -1,    69,    70,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,     3,    79,     5,     6,
      -1,    -1,    -1,    -1,    -1,    -1,    88,    89,    90,    91,
      92,    93,    -1,    20,    -1,    -1,    -1,    24,    25,    26,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
       3,    -1,     5,     6,    -1,    52,    53,    -1,    -1,    -1,
      -1,    -1,    59,    60,    61,    62,    63,    20,    65,    -1,
      67,    24,    25,    26,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    79,    -1,    -1,    -1,    -1,    84,    -1,    -1,
      -1,    88,    89,    90,    91,    92,    93,    -1,    -1,    52,
      53,     3,    -1,     5,     6,    -1,    59,    60,    61,    62,
      63,    -1,    65,    -1,    67,    -1,    -1,    -1,    20,    -1,
      -1,    -1,    24,    25,    26,    -1,    79,    -1,    -1,    -1,
      -1,    84,    -1,    -1,    -1,    88,    89,    90,    91,    92,
      93,    -1,    -1,    -1,    -1,     3,    -1,     5,     6,    -1,
      52,    53,    -1,    -1,    -1,    -1,    -1,    59,    60,    61,
      62,    63,    20,    65,    -1,    67,    24,    25,    26,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,    -1,    -1,
      -1,    -1,    84,    -1,    -1,    -1,    88,    89,    90,    91,
      92,    93,    -1,    -1,    52,    53,     3,    -1,     5,     6,
      -1,    59,    60,    61,    62,    63,    -1,    65,    -1,    67,
      -1,    -1,    -1,    20,    -1,    -1,    -1,    24,    25,    26,
      -1,    79,    -1,    -1,    -1,    -1,    84,    -1,    -1,    -1,
      88,    89,    90,    91,    92,    93,    -1,    -1,    -1,    -1,
       3,    -1,     5,     6,    -1,    52,    53,    -1,    -1,    -1,
      -1,    -1,    59,    60,    61,    62,    63,    20,    65,    -1,
      67,    24,    25,    26,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    79,    -1,    -1,    -1,    -1,    84,    -1,    -1,
      -1,    88,    89,    90,    91,    92,    93,    -1,    -1,    52,
      53,     3,    -1,     5,     6,    -1,    59,    60,    61,    62,
      63,    -1,    65,    -1,    67,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    24,    25,    26,    -1,    79,    -1,    -1,    -1,
      -1,    84,    -1,    -1,    -1,    88,    89,    90,    91,    92,
      93,    -1,    -1,     3,    -1,     5,     6,    -1,    -1,    -1,
      52,    53,    -1,    -1,    -1,    -1,    -1,    59,    60,    61,
      62,    63,    -1,    65,    -1,    67,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,     3,    -1,
       5,     6,    -1,    -1,    -1,    -1,    88,    89,    90,    91,
      92,    93,    52,    -1,    -1,    -1,    -1,    -1,    -1,    59,
      60,    61,    62,    63,    -1,    65,    -1,    67,    -1,    -1,
      -1,    -1,    -1,     3,    -1,     5,     6,    -1,    -1,    79,
      -1,    -1,    -1,    -1,    -1,    -1,    86,    52,    88,    89,
      90,    91,    92,    93,    59,    60,    61,    62,    63,    -1,
      65,    -1,    67,    -1,    -1,    -1,    -1,    -1,     3,    -1,
       5,     6,    -1,    -1,    79,    80,    -1,    -1,    -1,    -1,
      -1,    -1,    52,    88,    89,    90,    91,    92,    93,    59,
      60,    61,    62,    63,    -1,    65,    -1,    67,    -1,    -1,
      -1,    -1,    -1,     3,    -1,     5,     6,    -1,    -1,    79,
      -1,    -1,    -1,    -1,    -1,    -1,    86,    52,    88,    89,
      90,    91,    92,    93,    59,    60,    61,    62,    63,    -1,
      65,    -1,    67,    -1,    -1,    -1,    -1,    -1,     3,    -1,
       5,     6,    -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,
      -1,    86,    52,    88,    89,    90,    91,    92,    93,    59,
      60,    61,    62,    63,    -1,    65,    -1,    67,    -1,    -1,
      -1,    -1,    -1,     3,    -1,     5,     6,    -1,    -1,    79,
      80,    -1,    -1,    -1,    -1,    -1,    -1,    52,    88,    89,
      90,    91,    92,    93,    59,    60,    61,    62,    63,    -1,
      65,    -1,    67,    -1,    -1,    -1,    -1,    -1,     3,    -1,
       5,     6,    -1,    -1,    79,    80,    -1,    -1,    -1,    -1,
      -1,    -1,    52,    88,    89,    90,    91,    92,    93,    59,
      60,    61,    62,    63,    -1,    65,    -1,    67,    -1,    -1,
      -1,    -1,    -1,     3,    -1,     5,     6,    -1,    -1,    79,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    52,    88,    89,
      90,    91,    92,    93,    59,    60,    61,    62,    63,    -1,
      65,    -1,    67,    -1,    -1,    -1,    -1,    -1,     3,    -1,
       5,     6,    -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    52,    88,    89,    90,    91,    92,    93,    59,
      60,    61,    62,    63,    -1,    65,    -1,    67,    -1,    -1,
      -1,    -1,    -1,     3,    -1,     5,     6,    -1,    -1,    79,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    52,    88,    89,
      90,    91,    92,    93,    59,    60,    61,    62,    63,    -1,
      65,    -1,    67,    -1,    -1,    -1,    -1,    -1,     3,    -1,
       5,     6,    -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    52,    88,    89,    90,    91,    92,    93,    59,
      60,    61,    62,    63,    -1,    65,    -1,    67,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    52,    88,    89,
      90,    91,    92,    93,    59,    60,    61,    62,    63,    -1,
      65,    -1,    67,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    88,    89,    90,    91,    92,    93,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    51,    -1,    53,    54,    55,    56,    57,
      58,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    69,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    86,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   101,    17,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    51,    -1,
      53,    54,    -1,    56,    57,    58,    59,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    69,    70,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    79,    80,    -1,    -1,
      83,    -1,    -1,    -1,    -1,    -1,    89,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    51,    -1,    53,    54,    -1,    56,    57,    58,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    69,
      70,    -1,    -1,     0,    -1,    -1,    -1,    -1,    -1,    79,
      80,    -1,    -1,    83,    -1,    -1,    -1,    -1,    -1,    89,
      17,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    51,    -1,    53,    54,    55,    56,
      57,    58,    -1,    -1,    -1,    -1,    -1,    17,    -1,    -1,
      -1,    -1,    69,    70,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    53,    -1,    55,    -1,    57,    58,    -1,
      -1,    -1,    -1,    -1,    17,    -1,    -1,    -1,    -1,    69,
      70,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      53,    -1,    55,    -1,    57,    58,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    69,    70,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    87,    17,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    51,
      -1,    53,    54,    55,    56,    57,    58,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    69,    70,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    86,    17,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    51,
      -1,    53,    54,    -1,    56,    57,    58,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    69,    70,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,    -1,
      -1,    83,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    51,    -1,    53,    54,
      -1,    56,    57,    58,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    69,    70,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    80,    -1,    -1,    83,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    51,    -1,    53,    54,    -1,    56,    57,
      58,    59,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    69,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    80,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    51,    -1,    53,
      54,    -1,    56,    57,    58,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    69,    70,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    80,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    51,    -1,    53,    54,    -1,    56,    57,    58,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    69,
      70,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    51,    -1,    53,    54,    -1,
      56,    57,    58,    -1,    -1,    -1,    -1,    -1,    17,    -1,
      -1,    -1,    -1,    69,    70,    24,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    53,    -1,    55,    -1,    57,    58,
      -1,    -1,    -1,    -1,    -1,    17,    -1,    -1,    -1,    -1,
      69,    70,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    -1,    -1,    40,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    53,    -1,    -1,    -1,    57,    58,    -1,    -1,    -1,
      -1,    -1,    17,    -1,    -1,    -1,    -1,    69,    70,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    53,    -1,
      -1,    -1,    57,    58,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    69,    70
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    51,    53,    54,    55,    56,    57,    58,    69,
      70,   131,   132,   135,   136,   137,   138,   144,   147,   148,
     149,   150,   164,   174,   175,   176,    59,    86,    79,    79,
      79,    59,    79,    89,   102,   133,   134,   151,   152,   153,
     132,   132,    59,    86,   132,   132,   132,     0,   175,    86,
      59,   106,   145,   146,     3,     5,     6,    52,    59,    60,
      61,    62,    63,    65,    67,    79,    88,    89,    90,    91,
      92,    93,   104,   105,   107,   108,   111,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   130,   136,   141,   148,   159,   159,   130,   151,    53,
     148,   153,   154,    81,   102,    86,   101,   131,   132,   167,
     177,    79,    83,   152,    86,   139,   140,   141,   164,   145,
     101,    81,    87,    79,   113,    79,   113,   113,    79,    79,
     113,   126,   127,   129,   159,     4,     5,     6,    79,    83,
      85,   115,    89,    94,    95,    90,    91,    77,    78,    71,
      72,    96,    97,    73,    74,    88,    98,    99,    75,    76,
     100,    80,   141,    79,    83,   153,   160,   161,   141,    80,
      80,    81,    80,   148,   153,   134,   151,    39,    40,    41,
      43,    44,    45,    46,    47,    48,    49,    50,    59,    87,
     102,   129,   131,   165,   166,   167,   168,   169,   170,   171,
     172,   173,    86,   127,   162,   131,   167,    59,    80,   132,
     155,   156,   157,   158,    20,    84,    89,   127,   154,   139,
      87,   140,    82,   102,   142,   143,   151,    81,    87,   130,
      87,   146,   159,   159,   159,   127,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,   101,   128,    80,    81,
      80,    59,    80,   112,   127,   129,    59,   115,   115,   115,
     116,   116,   117,   117,   118,   118,   118,   118,   119,   119,
     120,   121,   122,   123,   124,   129,    80,   155,   160,    20,
      84,    89,   127,   154,   161,    79,    83,    60,   130,    82,
      79,   129,    79,   129,    79,   129,   165,    79,   131,   170,
      59,   102,   102,   102,   129,    82,   102,    87,   169,   162,
     163,    79,   151,   153,   160,    80,    81,    80,    81,   127,
     154,    84,    84,    20,    84,    89,   127,    87,   130,    81,
     102,    82,    87,    80,    80,    80,    81,   127,   127,    86,
     115,    80,    81,    84,    82,    80,    80,   127,   154,    84,
      84,    20,    84,   127,    80,   155,    20,    84,    89,   127,
     154,    80,    82,   165,   129,   167,   129,   167,   129,   167,
      44,   129,   131,   136,   148,   170,   170,   170,   102,   102,
     165,    81,    87,    38,   157,    59,    84,   127,   127,    84,
      84,   143,   130,    40,   109,   110,   159,   163,   127,   126,
      84,   127,   127,    84,    80,   127,   154,    84,    84,    20,
      84,   127,   102,   165,    80,    42,    80,    80,    79,   170,
     170,   129,   167,   167,   170,    87,    84,    84,    82,    80,
      81,    82,    81,    87,    84,    84,    84,   127,   127,    84,
     165,   167,   165,   165,   129,    80,   129,    80,   129,   167,
     167,   127,   110,   127,    87,    84,    84,    42,    80,   165,
      80,   165,    80,   165,   102,   165,   165
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_uint8 yyr1[] =
{
       0,   103,   104,   104,   104,   104,   104,   105,   105,   105,
     106,   107,   107,   108,   109,   109,   110,   110,   111,   111,
     111,   111,   111,   111,   111,   111,   111,   111,   112,   112,
     113,   113,   113,   113,   113,   113,   113,   114,   114,   114,
     114,   114,   114,   115,   115,   116,   116,   116,   116,   117,
     117,   117,   118,   118,   118,   119,   119,   119,   119,   119,
     120,   120,   120,   121,   121,   122,   122,   123,   123,   124,
     124,   125,   125,   126,   126,   127,   127,   128,   128,   128,
     128,   128,   128,   128,   128,   128,   128,   128,   129,   129,
     130,   131,   131,   131,   132,   132,   132,   132,   132,   132,
     132,   132,   132,   132,   133,   133,   134,   134,   135,   135,
     135,   135,   135,   135,   136,   136,   136,   136,   136,   136,
     136,   136,   136,   136,   136,   136,   136,   136,   136,   136,
     137,   137,   137,   138,   138,   139,   139,   140,   140,   140,
     141,   141,   141,   141,   142,   142,   143,   143,   143,   144,
     144,   144,   144,   144,   145,   145,   146,   146,   147,   148,
     148,   148,   148,   149,   149,   150,   150,   151,   151,   152,
     152,   152,   152,   152,   152,   152,   152,   152,   152,   152,
     152,   152,   152,   153,   153,   153,   153,   154,   154,   155,
     155,   156,   156,   157,   157,   157,   158,   158,   159,   159,
     160,   160,   160,   161,   161,   161,   161,   161,   161,   161,
     161,   161,   161,   161,   161,   161,   161,   161,   161,   161,
     161,   161,   161,   161,   162,   162,   162,   163,   164,   165,
     165,   165,   165,   165,   165,   166,   166,   166,   167,   167,
     168,   168,   169,   169,   170,   170,   171,   171,   171,   171,
     171,   171,   172,   172,   172,   172,   172,   172,   172,   172,
     172,   172,   172,   173,   173,   173,   173,   173,   174,   174,
     175,   175,   176,   176,   177,   177
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     1,     3,     1,     1,     1,     1,
       1,     1,     1,     6,     1,     3,     3,     3,     1,     4,
       3,     4,     3,     3,     2,     2,     6,     7,     1,     3,
       1,     2,     2,     2,     2,     4,     4,     1,     1,     1,
       1,     1,     1,     1,     4,     1,     3,     3,     3,     1,
       3,     3,     1,     3,     3,     1,     3,     3,     3,     3,
       1,     3,     3,     1,     3,     1,     3,     1,     3,     1,
       3,     1,     3,     1,     5,     1,     3,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     3,
       1,     2,     3,     1,     2,     1,     2,     1,     2,     1,
       2,     1,     2,     1,     1,     3,     3,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       4,     5,     2,     1,     1,     1,     2,     2,     3,     1,
       2,     1,     2,     1,     1,     3,     2,     3,     1,     4,
       5,     5,     6,     2,     1,     3,     3,     1,     4,     1,
       1,     1,     1,     1,     1,     4,     4,     2,     1,     1,
       3,     3,     4,     6,     5,     5,     6,     5,     4,     4,
       4,     3,     4,     3,     2,     2,     1,     1,     2,     3,
       1,     1,     3,     2,     2,     1,     1,     3,     2,     1,
       2,     1,     1,     3,     2,     3,     5,     4,     5,     4,
       3,     3,     3,     4,     6,     5,     5,     6,     4,     4,
       2,     3,     3,     4,     3,     4,     1,     1,     7,     1,
       1,     1,     1,     1,     1,     3,     4,     3,     2,     3,
       1,     2,     1,     1,     1,     2,     7,     5,     5,     3,
       5,     3,     5,     3,     7,     4,     5,     5,     4,     6,
       7,     6,     7,     3,     2,     2,     2,     3,     1,     2,
       1,     1,     4,     3,     1,     2
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* primary_expression: IDENTIFIER  */
#line 90 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_identifier_node((yyvsp[0].id)); }
#line 2149 "c11.tab.c"
    break;

  case 5: /* primary_expression: '(' expression ')'  */
#line 93 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                             { (yyval.node) = (yyvsp[-1].node); }
#line 2155 "c11.tab.c"
    break;

  case 7: /* constant: I_CONSTANT  */
#line 98 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_constant_node((yyvsp[0].intval)); }
#line 2161 "c11.tab.c"
    break;

  case 8: /* constant: F_CONSTANT  */
#line 99 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_constant_node((yyvsp[0].floatval)); }
#line 2167 "c11.tab.c"
    break;

  case 9: /* constant: ENUMERATION_CONSTANT  */
#line 100 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                               { (yyval.node) = make_identifier_node((yyvsp[0].id)); }
#line 2173 "c11.tab.c"
    break;

  case 10: /* enumeration_constant: IDENTIFIER  */
#line 104 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_identifier_node((yyvsp[0].id)); }
#line 2179 "c11.tab.c"
    break;

  case 11: /* string: STRING_LITERAL  */
#line 108 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                         { (yyval.id) = make_string_node((yyvsp[0].id)); }
#line 2185 "c11.tab.c"
    break;

  case 12: /* string: FUNC_NAME  */
#line 109 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                    { (yyval.id) = make_string_node((yyvsp[0].id)); }
#line 2191 "c11.tab.c"
    break;

  case 13: /* generic_selection: GENERIC '(' assignment_expression ',' generic_assoc_list ')'  */
#line 113 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                       { zig_error(); }
#line 2197 "c11.tab.c"
    break;

  case 20: /* postfix_expression: postfix_expression '(' ')'  */
#line 129 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                     { (yyval.node) = make_function_call_node((yyvsp[-2].node), NULL); }
#line 2203 "c11.tab.c"
    break;

  case 21: /* postfix_expression: postfix_expression '(' argument_expression_list ')'  */
#line 130 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                              { (yyval.node) = make_function_call_node((yyvsp[-3].node), (yyvsp[-1].node)); }
#line 2209 "c11.tab.c"
    break;

  case 28: /* argument_expression_list: assignment_expression  */
#line 140 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                { (yyval.node) = append_argument_list((yyvsp[0].node), NULL); }
#line 2215 "c11.tab.c"
    break;

  case 29: /* argument_expression_list: argument_expression_list ',' assignment_expression  */
#line 141 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                             { (yyval.node) = append_argument_list((yyvsp[0].node), (yyvsp[-2].node)); }
#line 2221 "c11.tab.c"
    break;

  case 46: /* multiplicative_expression: multiplicative_expression '*' cast_expression  */
#line 170 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        { (yyval.node) = make_binary_node((yyvsp[-2].node), '*', (yyvsp[0].node));}
#line 2227 "c11.tab.c"
    break;

  case 47: /* multiplicative_expression: multiplicative_expression '/' cast_expression  */
#line 171 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        { (yyval.node) = make_binary_node((yyvsp[-2].node), '/', (yyvsp[0].node));}
#line 2233 "c11.tab.c"
    break;

  case 48: /* multiplicative_expression: multiplicative_expression '%' cast_expression  */
#line 172 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        { (yyval.node) = make_binary_node((yyvsp[-2].node), '%', (yyvsp[0].node));}
#line 2239 "c11.tab.c"
    break;

  case 50: /* additive_expression: additive_expression '+' multiplicative_expression  */
#line 177 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                            { (yyval.node) = make_binary_node((yyvsp[-2].node), '+', (yyvsp[0].node));}
#line 2245 "c11.tab.c"
    break;

  case 51: /* additive_expression: additive_expression '-' multiplicative_expression  */
#line 178 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                            { (yyval.node) = make_binary_node((yyvsp[-2].node), '-', (yyvsp[0].node));}
#line 2251 "c11.tab.c"
    break;

  case 53: /* shift_expression: shift_expression LEFT_OP additive_expression  */
#line 183 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                       { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), (yyvsp[-1].intval), (yyvsp[0].node));}
#line 2257 "c11.tab.c"
    break;

  case 54: /* shift_expression: shift_expression RIGHT_OP additive_expression  */
#line 184 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), (yyvsp[-1].intval), (yyvsp[0].node));}
#line 2263 "c11.tab.c"
    break;

  case 56: /* relational_expression: relational_expression '<' shift_expression  */
#line 189 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { (yyval.node) = make_binary_node((yyvsp[-2].node), '<', (yyvsp[0].node));}
#line 2269 "c11.tab.c"
    break;

  case 57: /* relational_expression: relational_expression '>' shift_expression  */
#line 190 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { (yyval.node) = make_binary_node((yyvsp[-2].node), '>', (yyvsp[0].node));}
#line 2275 "c11.tab.c"
    break;

  case 58: /* relational_expression: relational_expression LE_OP shift_expression  */
#line 191 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                       { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), LE_OP, (yyvsp[0].node));}
#line 2281 "c11.tab.c"
    break;

  case 59: /* relational_expression: relational_expression GE_OP shift_expression  */
#line 192 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                       { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), GE_OP, (yyvsp[0].node));}
#line 2287 "c11.tab.c"
    break;

  case 61: /* equality_expression: equality_expression EQ_OP relational_expression  */
#line 197 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                          { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), EQ_OP, (yyvsp[0].node));}
#line 2293 "c11.tab.c"
    break;

  case 62: /* equality_expression: equality_expression NE_OP relational_expression  */
#line 198 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                          { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), NE_OP, (yyvsp[0].node));}
#line 2299 "c11.tab.c"
    break;

  case 64: /* and_expression: and_expression '&' equality_expression  */
#line 203 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                 { (yyval.node) = make_binary_node((yyvsp[-2].node), '&', (yyvsp[0].node)); }
#line 2305 "c11.tab.c"
    break;

  case 66: /* exclusive_or_expression: exclusive_or_expression '^' and_expression  */
#line 208 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { (yyval.node) = make_binary_node((yyvsp[-2].node), '^', (yyvsp[0].node));}
#line 2311 "c11.tab.c"
    break;

  case 68: /* inclusive_or_expression: inclusive_or_expression '|' exclusive_or_expression  */
#line 213 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                              { (yyval.node) = make_binary_node((yyvsp[-2].node), '|', (yyvsp[0].node));}
#line 2317 "c11.tab.c"
    break;

  case 70: /* logical_and_expression: logical_and_expression AND_OP inclusive_or_expression  */
#line 218 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), AND_OP, (yyvsp[0].node));}
#line 2323 "c11.tab.c"
    break;

  case 72: /* logical_or_expression: logical_or_expression OR_OP logical_and_expression  */
#line 223 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                             { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), OR_OP, (yyvsp[0].node));}
#line 2329 "c11.tab.c"
    break;

  case 76: /* assignment_expression: unary_expression assignment_operator assignment_expression  */
#line 233 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                     { (yyval.node) = make_assignment_node((yyvsp[-2].node), (yyvsp[0].node)); }
#line 2335 "c11.tab.c"
    break;

  case 89: /* expression: expression ',' assignment_expression  */
#line 252 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                               { zig_error(); }
#line 2341 "c11.tab.c"
    break;

  case 91: /* declaration: declaration_specifiers ';'  */
#line 260 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                     { (yyval.node) = make_declaration_node((yyvsp[-1].node), NULL); }
#line 2347 "c11.tab.c"
    break;

  case 92: /* declaration: declaration_specifiers init_declarator_list ';'  */
#line 261 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                          { (yyval.node) = make_declaration_node((yyvsp[-2].node), (yyvsp[-1].node)); }
#line 2353 "c11.tab.c"
    break;

  case 93: /* declaration: static_assert_declaration  */
#line 262 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { zig_error(); }
#line 2359 "c11.tab.c"
    break;

  case 94: /* declaration_specifiers: storage_class_specifier declaration_specifiers  */
#line 266 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                         { zig_error(); }
#line 2365 "c11.tab.c"
    break;

  case 95: /* declaration_specifiers: storage_class_specifier  */
#line 267 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                  { zig_error(); }
#line 2371 "c11.tab.c"
    break;

  case 98: /* declaration_specifiers: type_qualifier declaration_specifiers  */
#line 270 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                { zig_error(); }
#line 2377 "c11.tab.c"
    break;

  case 99: /* declaration_specifiers: type_qualifier  */
#line 271 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                         { zig_error(); }
#line 2383 "c11.tab.c"
    break;

  case 100: /* declaration_specifiers: function_specifier declaration_specifiers  */
#line 272 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                    { zig_error(); }
#line 2389 "c11.tab.c"
    break;

  case 101: /* declaration_specifiers: function_specifier  */
#line 273 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                             { zig_error(); }
#line 2395 "c11.tab.c"
    break;

  case 102: /* declaration_specifiers: alignment_specifier declaration_specifiers  */
#line 274 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { zig_error(); }
#line 2401 "c11.tab.c"
    break;

  case 103: /* declaration_specifiers: alignment_specifier  */
#line 275 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                              { zig_error(); }
#line 2407 "c11.tab.c"
    break;

  case 106: /* init_declarator: declarator '=' initializer  */
#line 284 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                     { (yyval.node) = make_assignment_node((yyvsp[-2].node), (yyvsp[0].node)); }
#line 2413 "c11.tab.c"
    break;

  case 107: /* init_declarator: declarator  */
#line 285 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     {(yyval.node) = make_assignment_node((yyvsp[0].node), NULL); }
#line 2419 "c11.tab.c"
    break;

  case 114: /* type_specifier: VOID  */
#line 298 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
               { 
        (yyval.node) = make_type_node(VOID);
    }
#line 2427 "c11.tab.c"
    break;

  case 115: /* type_specifier: CHAR  */
#line 301 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
               { 
        (yyval.node) = make_type_node(CHAR);
    }
#line 2435 "c11.tab.c"
    break;

  case 116: /* type_specifier: SHORT  */
#line 304 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                { 
        (yyval.node) = make_type_node(SHORT);
    }
#line 2443 "c11.tab.c"
    break;

  case 117: /* type_specifier: INT  */
#line 307 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
              { 
        (yyval.node) = make_type_node(INT);
    }
#line 2451 "c11.tab.c"
    break;

  case 118: /* type_specifier: LONG  */
#line 310 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
               { 
        (yyval.node) = make_type_node(LONG);
    }
#line 2459 "c11.tab.c"
    break;

  case 119: /* type_specifier: FLOAT  */
#line 313 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                { 
        (yyval.node) = make_type_node(FLOAT);
    }
#line 2467 "c11.tab.c"
    break;

  case 120: /* type_specifier: DOUBLE  */
#line 316 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                 { 
        (yyval.node) = make_type_node(DOUBLE);
    }
#line 2475 "c11.tab.c"
    break;

  case 121: /* type_specifier: SIGNED  */
#line 319 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                 { 
        (yyval.node) = make_type_node(SIGNED);
    }
#line 2483 "c11.tab.c"
    break;

  case 122: /* type_specifier: UNSIGNED  */
#line 322 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                   { 
        (yyval.node) = make_type_node(UNSIGNED);
    }
#line 2491 "c11.tab.c"
    break;

  case 123: /* type_specifier: BOOL  */
#line 325 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
               { 
        (yyval.node) = make_type_node(BOOL);
    }
#line 2499 "c11.tab.c"
    break;

  case 124: /* type_specifier: COMPLEX  */
#line 328 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                  { 
        (yyval.node) = make_type_node(COMPLEX);
    }
#line 2507 "c11.tab.c"
    break;

  case 125: /* type_specifier: IMAGINARY  */
#line 331 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                   { 
        (yyval.node) = make_type_node(IMAGINARY);
    }
#line 2515 "c11.tab.c"
    break;

  case 126: /* type_specifier: atomic_type_specifier  */
#line 334 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                { zig_error(); }
#line 2521 "c11.tab.c"
    break;

  case 127: /* type_specifier: struct_or_union_specifier  */
#line 335 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { zig_error(); }
#line 2527 "c11.tab.c"
    break;

  case 128: /* type_specifier: enum_specifier  */
#line 336 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                         { zig_error(); }
#line 2533 "c11.tab.c"
    break;

  case 129: /* type_specifier: TYPEDEF_NAME  */
#line 337 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                       { zig_error(); }
#line 2539 "c11.tab.c"
    break;

  case 133: /* struct_or_union: STRUCT  */
#line 347 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                 { (yyval.node) = STRUCT; }
#line 2545 "c11.tab.c"
    break;

  case 134: /* struct_or_union: UNION  */
#line 348 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                { (yyval.node) = UNION; }
#line 2551 "c11.tab.c"
    break;

  case 135: /* struct_declaration_list: struct_declaration  */
#line 352 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                             { (yyval.node) = append_struct_decl_list((yyvsp[0].node)); }
#line 2557 "c11.tab.c"
    break;

  case 136: /* struct_declaration_list: struct_declaration_list struct_declaration  */
#line 353 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { (yyval.node) = append_struct_decl_list((yyvsp[0].node), (yyvsp[-1].node)); }
#line 2563 "c11.tab.c"
    break;

  case 137: /* struct_declaration: specifier_qualifier_list ';'  */
#line 357 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                       { make_struct_decl((yyvsp[-1].node)); }
#line 2569 "c11.tab.c"
    break;

  case 138: /* struct_declaration: specifier_qualifier_list struct_declarator_list ';'  */
#line 358 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                              { make_struct_decl((yyvsp[-2].node), (yyvsp[-1].node)); }
#line 2575 "c11.tab.c"
    break;

  case 144: /* struct_declarator_list: struct_declarator  */
#line 370 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                            { (yyval.node) = append_struct_declarator_list((yyvsp[0].node)); }
#line 2581 "c11.tab.c"
    break;

  case 145: /* struct_declarator_list: struct_declarator_list ',' struct_declarator  */
#line 371 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                       { (yyval.node) = append_struct_declarator_list((yyvsp[0].node), (yyvsp[-2].node)); }
#line 2587 "c11.tab.c"
    break;

  case 167: /* declarator: pointer direct_declarator  */
#line 420 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { (yyval.node) = make_idpointer_node((yyvsp[-1].node), (yyvsp[0].node)); }
#line 2593 "c11.tab.c"
    break;

  case 169: /* direct_declarator: IDENTIFIER  */
#line 425 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_identifier_node((yyvsp[0].id)); }
#line 2599 "c11.tab.c"
    break;

  case 170: /* direct_declarator: '(' declarator ')'  */
#line 426 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                             { (yyval.node) = (yyvsp[-1].node); }
#line 2605 "c11.tab.c"
    break;

  case 180: /* direct_declarator: direct_declarator '(' parameter_type_list ')'  */
#line 436 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        {(yyval.node) = make_name_parameter_node((yyvsp[-3].node), (yyvsp[-1].node)); }
#line 2611 "c11.tab.c"
    break;

  case 181: /* direct_declarator: direct_declarator '(' ')'  */
#line 437 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { (yyval.node) = make_name_parameter_node((yyvsp[-2].node), NULL); }
#line 2617 "c11.tab.c"
    break;

  case 185: /* pointer: '*' pointer  */
#line 444 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                      { (yyval.node) = make_pointer_node((yyvsp[0].node)); }
#line 2623 "c11.tab.c"
    break;

  case 186: /* pointer: '*'  */
#line 445 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
              { (yyval.node) = make_pointer_node(NULL); }
#line 2629 "c11.tab.c"
    break;

  case 191: /* parameter_list: parameter_declaration  */
#line 460 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                { (yyval.node) = append_parameter_list((yyvsp[0].node), NULL); }
#line 2635 "c11.tab.c"
    break;

  case 192: /* parameter_list: parameter_list ',' parameter_declaration  */
#line 461 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                   { (yyval.node) = append_parameter_list((yyvsp[0].node), (yyvsp[-2].node)); }
#line 2641 "c11.tab.c"
    break;

  case 193: /* parameter_declaration: declaration_specifiers declarator  */
#line 465 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                            { (yyval.node) = make_assignment_node((yyvsp[0].node), NULL); }
#line 2647 "c11.tab.c"
    break;

  case 195: /* parameter_declaration: declaration_specifiers  */
#line 467 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                 { (yyval.node) = make_assignment_node((yyvsp[0].node), NULL); }
#line 2653 "c11.tab.c"
    break;

  case 224: /* initializer: '{' initializer_list '}'  */
#line 511 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                   { (yyval.node) = (yyvsp[-1].node); }
#line 2659 "c11.tab.c"
    break;

  case 225: /* initializer: '{' initializer_list ',' '}'  */
#line 512 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                       { (yyval.node) = (yyvsp[-2].node); }
#line 2665 "c11.tab.c"
    break;

  case 238: /* compound_statement: '{' '}'  */
#line 557 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                  { printf("Empty Block Found\n"); }
#line 2671 "c11.tab.c"
    break;

  case 239: /* compound_statement: '{' block_item_list '}'  */
#line 558 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                   { (yyval.node) = (yyvsp[-1].node); }
#line 2677 "c11.tab.c"
    break;

  case 240: /* block_item_list: block_item  */
#line 562 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { printf("Matched Block_Item\n"); (yyval.node) = append_block_list((yyvsp[0].node), NULL); }
#line 2683 "c11.tab.c"
    break;

  case 241: /* block_item_list: block_item_list block_item  */
#line 563 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                     { printf("Matched Block List then Block Item\n"); (yyval.node) = append_block_list((yyvsp[0].node), (yyvsp[-1].node)); }
#line 2689 "c11.tab.c"
    break;

  case 242: /* block_item: declaration  */
#line 567 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                      { printf("Declaration Found\n"); }
#line 2695 "c11.tab.c"
    break;

  case 243: /* block_item: statement  */
#line 568 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                    { printf("Statement Found\n"); }
#line 2701 "c11.tab.c"
    break;

  case 244: /* expression_statement: ';'  */
#line 572 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
              { (yyval.node) = make_expr_stmt(NULL); }
#line 2707 "c11.tab.c"
    break;

  case 245: /* expression_statement: expression ';'  */
#line 573 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                         { (yyval.node) = make_expr_stmt((yyvsp[-1].node)); }
#line 2713 "c11.tab.c"
    break;

  case 246: /* selection_statement: IF '(' expression ')' statement ELSE statement  */
#line 577 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                         { (yyval.node) = make_if_stmt((yyvsp[-4].node), (yyvsp[-2].node), (yyvsp[0].node)); }
#line 2719 "c11.tab.c"
    break;

  case 247: /* selection_statement: IF '(' expression ')' statement  */
#line 578 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                          { (yyval.node) = make_if_stmt((yyvsp[-2].node), (yyvsp[0].node), NULL); }
#line 2725 "c11.tab.c"
    break;

  case 248: /* selection_statement: IF expression compound_statement ELSE compound_statement  */
#line 579 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                               { (yyval.node) = make_if_stmt((yyvsp[-3].node), (yyvsp[-2].node), (yyvsp[0].node)); }
#line 2731 "c11.tab.c"
    break;

  case 249: /* selection_statement: IF expression compound_statement  */
#line 580 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                       { (yyval.node) = make_if_stmt((yyvsp[-1].node), (yyvsp[0].node), NULL); }
#line 2737 "c11.tab.c"
    break;

  case 252: /* iteration_statement: WHILE '(' expression ')' statement  */
#line 586 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                             { (yyval.node) = make_iteration_stmt((yyvsp[-2].node), (yyvsp[0].node), NULL, NULL); }
#line 2743 "c11.tab.c"
    break;

  case 253: /* iteration_statement: WHILE expression compound_statement  */
#line 587 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                              { (yyval.node) = make_iteration_stmt((yyvsp[-1].node), (yyvsp[0].node), NULL, NULL); }
#line 2749 "c11.tab.c"
    break;

  case 262: /* iteration_statement: FOR '(' declaration expression_statement expression ')' statement  */
#line 596 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                            {(yyval.node) = make_iteration_stmt((yyvsp[-3].node), (yyvsp[0].node), (yyvsp[-4].node), (yyvsp[-2].node));}
#line 2755 "c11.tab.c"
    break;

  case 266: /* jump_statement: RETURN ';'  */
#line 603 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_return_node(NULL); }
#line 2761 "c11.tab.c"
    break;

  case 267: /* jump_statement: RETURN expression ';'  */
#line 604 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                { (yyval.node) = make_return_node((yyvsp[-1].node)); }
#line 2767 "c11.tab.c"
    break;

  case 268: /* translation_unit: external_declaration  */
#line 608 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                               { 
        printf("[DEBUG] Assigning Root External_Declaration\n");
        fflush(stdout);
        root = (yyvsp[0].node); 
    }
#line 2777 "c11.tab.c"
    break;

  case 272: /* function_definition: declaration_specifiers declarator declaration_list compound_statement  */
#line 622 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                                { zig_error(); }
#line 2783 "c11.tab.c"
    break;

  case 273: /* function_definition: declaration_specifiers declarator compound_statement  */
#line 623 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                               {(yyval.node) = make_function_node((yyvsp[-2].node), (yyvsp[-1].node), (yyvsp[0].node)); }
#line 2789 "c11.tab.c"
    break;


#line 2793 "c11.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 631 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"


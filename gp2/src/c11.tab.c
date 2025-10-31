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
struct Node* make_assignment_node(struct Node* declarator, struct Node* initializer, struct Node* ass_op);
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
struct Node* make_post_fix_node(struct Node* base, enum yytokentype operator);
struct Node* make_pre_fix_node(enum yytokentype operator, struct Node* base);
struct Node* combine_type_node(struct Node* left, struct Node* right);
struct Node* append_struct_decl_list(struct Node* decl, struct Node* decls);
struct Node* append_struct_declarator_list(struct Node* declarator, struct Node* declarators);
struct Node* make_struct_decl(struct Node* identifier_node, struct Node* decl_list_node);
struct Node* make_struct_or_union(struct Node* struct_or_union, const char* s, struct Node* d_list);
struct Node* make_structunion_node(enum yytokentype t);
struct Node* append_translation_unit(struct Node* unit, struct Node* prev);

struct Node* make_assignment_op_node(enum yytokentype token);
struct Node* make_float_node(float f);

extern struct Node* root;

#line 125 "c11.tab.c"

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
  YYSYMBOL_TYPEDEF_NAME = 7,               /* TYPEDEF_NAME  */
  YYSYMBOL_TYPEDEF = 8,                    /* TYPEDEF  */
  YYSYMBOL_EXTERN = 9,                     /* EXTERN  */
  YYSYMBOL_STATIC = 10,                    /* STATIC  */
  YYSYMBOL_AUTO = 11,                      /* AUTO  */
  YYSYMBOL_REGISTER = 12,                  /* REGISTER  */
  YYSYMBOL_INLINE = 13,                    /* INLINE  */
  YYSYMBOL_CONST = 14,                     /* CONST  */
  YYSYMBOL_RESTRICT = 15,                  /* RESTRICT  */
  YYSYMBOL_VOLATILE = 16,                  /* VOLATILE  */
  YYSYMBOL_CHAR = 17,                      /* CHAR  */
  YYSYMBOL_SHORT = 18,                     /* SHORT  */
  YYSYMBOL_LONG = 19,                      /* LONG  */
  YYSYMBOL_SIGNED = 20,                    /* SIGNED  */
  YYSYMBOL_UNSIGNED = 21,                  /* UNSIGNED  */
  YYSYMBOL_VOID = 22,                      /* VOID  */
  YYSYMBOL_COMPLEX = 23,                   /* COMPLEX  */
  YYSYMBOL_IMAGINARY = 24,                 /* IMAGINARY  */
  YYSYMBOL_ENUM = 25,                      /* ENUM  */
  YYSYMBOL_ELLIPSIS = 26,                  /* ELLIPSIS  */
  YYSYMBOL_CASE = 27,                      /* CASE  */
  YYSYMBOL_DEFAULT = 28,                   /* DEFAULT  */
  YYSYMBOL_IF = 29,                        /* IF  */
  YYSYMBOL_ELSE = 30,                      /* ELSE  */
  YYSYMBOL_SWITCH = 31,                    /* SWITCH  */
  YYSYMBOL_WHILE = 32,                     /* WHILE  */
  YYSYMBOL_DO = 33,                        /* DO  */
  YYSYMBOL_FOR = 34,                       /* FOR  */
  YYSYMBOL_GOTO = 35,                      /* GOTO  */
  YYSYMBOL_CONTINUE = 36,                  /* CONTINUE  */
  YYSYMBOL_BREAK = 37,                     /* BREAK  */
  YYSYMBOL_RETURN = 38,                    /* RETURN  */
  YYSYMBOL_ALIGNAS = 39,                   /* ALIGNAS  */
  YYSYMBOL_ALIGNOF = 40,                   /* ALIGNOF  */
  YYSYMBOL_ATOMIC = 41,                    /* ATOMIC  */
  YYSYMBOL_NORETURN = 42,                  /* NORETURN  */
  YYSYMBOL_STATIC_ASSERT = 43,             /* STATIC_ASSERT  */
  YYSYMBOL_THREAD_LOCAL = 44,              /* THREAD_LOCAL  */
  YYSYMBOL_INT = 45,                       /* INT  */
  YYSYMBOL_FLOAT = 46,                     /* FLOAT  */
  YYSYMBOL_STRUCT = 47,                    /* STRUCT  */
  YYSYMBOL_UNION = 48,                     /* UNION  */
  YYSYMBOL_MUL_ASSIGN = 49,                /* MUL_ASSIGN  */
  YYSYMBOL_DIV_ASSIGN = 50,                /* DIV_ASSIGN  */
  YYSYMBOL_MOD_ASSIGN = 51,                /* MOD_ASSIGN  */
  YYSYMBOL_ADD_ASSIGN = 52,                /* ADD_ASSIGN  */
  YYSYMBOL_SUB_ASSIGN = 53,                /* SUB_ASSIGN  */
  YYSYMBOL_LEFT_ASSIGN = 54,               /* LEFT_ASSIGN  */
  YYSYMBOL_RIGHT_ASSIGN = 55,              /* RIGHT_ASSIGN  */
  YYSYMBOL_AND_ASSIGN = 56,                /* AND_ASSIGN  */
  YYSYMBOL_XOR_ASSIGN = 57,                /* XOR_ASSIGN  */
  YYSYMBOL_OR_ASSIGN = 58,                 /* OR_ASSIGN  */
  YYSYMBOL_DOUBLE = 59,                    /* DOUBLE  */
  YYSYMBOL_IDENTIFIER = 60,                /* IDENTIFIER  */
  YYSYMBOL_STRING_LITERAL = 61,            /* STRING_LITERAL  */
  YYSYMBOL_ENUMERATION_CONSTANT = 62,      /* ENUMERATION_CONSTANT  */
  YYSYMBOL_FUNC_NAME = 63,                 /* FUNC_NAME  */
  YYSYMBOL_GENERIC = 64,                   /* GENERIC  */
  YYSYMBOL_INT_CONST = 65,                 /* INT_CONST  */
  YYSYMBOL_I_CONSTANT = 66,                /* I_CONSTANT  */
  YYSYMBOL_FLOAT_CONST = 67,               /* FLOAT_CONST  */
  YYSYMBOL_F_CONSTANT = 68,                /* F_CONSTANT  */
  YYSYMBOL_DOUBLE_CONST = 69,              /* DOUBLE_CONST  */
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
  YYSYMBOL_type_specifier_list = 136,      /* type_specifier_list  */
  YYSYMBOL_type_specifier = 137,           /* type_specifier  */
  YYSYMBOL_struct_or_union_specifier = 138, /* struct_or_union_specifier  */
  YYSYMBOL_struct_or_union = 139,          /* struct_or_union  */
  YYSYMBOL_struct_declaration_list = 140,  /* struct_declaration_list  */
  YYSYMBOL_struct_declaration = 141,       /* struct_declaration  */
  YYSYMBOL_specifier_qualifier_list = 142, /* specifier_qualifier_list  */
  YYSYMBOL_struct_declarator_list = 143,   /* struct_declarator_list  */
  YYSYMBOL_struct_declarator = 144,        /* struct_declarator  */
  YYSYMBOL_enum_specifier = 145,           /* enum_specifier  */
  YYSYMBOL_enumerator_list = 146,          /* enumerator_list  */
  YYSYMBOL_enumerator = 147,               /* enumerator  */
  YYSYMBOL_atomic_type_specifier = 148,    /* atomic_type_specifier  */
  YYSYMBOL_type_qualifier = 149,           /* type_qualifier  */
  YYSYMBOL_function_specifier = 150,       /* function_specifier  */
  YYSYMBOL_alignment_specifier = 151,      /* alignment_specifier  */
  YYSYMBOL_declarator = 152,               /* declarator  */
  YYSYMBOL_direct_declarator = 153,        /* direct_declarator  */
  YYSYMBOL_pointer = 154,                  /* pointer  */
  YYSYMBOL_type_qualifier_list = 155,      /* type_qualifier_list  */
  YYSYMBOL_parameter_type_list = 156,      /* parameter_type_list  */
  YYSYMBOL_parameter_list = 157,           /* parameter_list  */
  YYSYMBOL_parameter_declaration = 158,    /* parameter_declaration  */
  YYSYMBOL_identifier_list = 159,          /* identifier_list  */
  YYSYMBOL_type_name = 160,                /* type_name  */
  YYSYMBOL_abstract_declarator = 161,      /* abstract_declarator  */
  YYSYMBOL_direct_abstract_declarator = 162, /* direct_abstract_declarator  */
  YYSYMBOL_initializer = 163,              /* initializer  */
  YYSYMBOL_initializer_list = 164,         /* initializer_list  */
  YYSYMBOL_static_assert_declaration = 165, /* static_assert_declaration  */
  YYSYMBOL_statement = 166,                /* statement  */
  YYSYMBOL_labeled_statement = 167,        /* labeled_statement  */
  YYSYMBOL_compound_statement = 168,       /* compound_statement  */
  YYSYMBOL_block_item_list = 169,          /* block_item_list  */
  YYSYMBOL_block_item = 170,               /* block_item  */
  YYSYMBOL_expression_statement = 171,     /* expression_statement  */
  YYSYMBOL_selection_statement = 172,      /* selection_statement  */
  YYSYMBOL_iteration_statement = 173,      /* iteration_statement  */
  YYSYMBOL_jump_statement = 174,           /* jump_statement  */
  YYSYMBOL_program = 175,                  /* program  */
  YYSYMBOL_translation_unit = 176,         /* translation_unit  */
  YYSYMBOL_external_declaration = 177,     /* external_declaration  */
  YYSYMBOL_function_definition = 178,      /* function_definition  */
  YYSYMBOL_declaration_list = 179          /* declaration_list  */
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
#define YYFINAL  70
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   3087

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  103
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  77
/* YYNRULES -- Number of rules.  */
#define YYNRULES  278
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  490

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
       0,   100,   100,   101,   102,   103,   104,   108,   109,   110,
     114,   118,   119,   123,   127,   128,   132,   133,   137,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   150,   151,
     155,   156,   157,   158,   159,   160,   161,   165,   166,   167,
     168,   169,   170,   174,   175,   179,   180,   181,   182,   186,
     187,   188,   192,   193,   194,   198,   199,   200,   201,   202,
     206,   207,   208,   212,   213,   217,   218,   222,   223,   227,
     228,   232,   233,   237,   238,   242,   243,   247,   248,   249,
     250,   251,   252,   253,   254,   255,   256,   257,   261,   262,
     266,   270,   271,   272,   276,   277,   278,   279,   280,   281,
     282,   283,   284,   285,   289,   290,   294,   295,   299,   300,
     301,   302,   303,   304,   308,   309,   313,   316,   319,   322,
     325,   328,   331,   334,   337,   340,   343,   346,   349,   350,
     351,   352,   356,   357,   358,   362,   363,   367,   368,   372,
     373,   374,   378,   379,   380,   381,   385,   386,   390,   391,
     392,   396,   397,   398,   399,   400,   404,   405,   409,   410,
     414,   418,   419,   420,   421,   425,   426,   430,   431,   435,
     436,   440,   441,   442,   443,   444,   445,   446,   447,   448,
     449,   450,   451,   452,   453,   457,   458,   459,   460,   464,
     465,   470,   471,   475,   476,   480,   481,   482,   486,   487,
     491,   492,   496,   497,   498,   502,   503,   504,   505,   506,
     507,   508,   509,   510,   511,   512,   513,   514,   515,   516,
     517,   518,   519,   520,   521,   522,   526,   527,   528,   533,
     553,   557,   558,   559,   560,   561,   562,   566,   567,   568,
     572,   573,   577,   578,   582,   583,   587,   588,   592,   593,
     594,   595,   596,   597,   601,   602,   603,   604,   605,   606,
     607,   608,   609,   610,   611,   615,   616,   617,   618,   619,
     623,   626,   629,   633,   634,   638,   639,   643,   644
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
  "INC_OP", "DEC_OP", "TYPEDEF_NAME", "TYPEDEF", "EXTERN", "STATIC",
  "AUTO", "REGISTER", "INLINE", "CONST", "RESTRICT", "VOLATILE", "CHAR",
  "SHORT", "LONG", "SIGNED", "UNSIGNED", "VOID", "COMPLEX", "IMAGINARY",
  "ENUM", "ELLIPSIS", "CASE", "DEFAULT", "IF", "ELSE", "SWITCH", "WHILE",
  "DO", "FOR", "GOTO", "CONTINUE", "BREAK", "RETURN", "ALIGNAS", "ALIGNOF",
  "ATOMIC", "NORETURN", "STATIC_ASSERT", "THREAD_LOCAL", "INT", "FLOAT",
  "STRUCT", "UNION", "MUL_ASSIGN", "DIV_ASSIGN", "MOD_ASSIGN",
  "ADD_ASSIGN", "SUB_ASSIGN", "LEFT_ASSIGN", "RIGHT_ASSIGN", "AND_ASSIGN",
  "XOR_ASSIGN", "OR_ASSIGN", "DOUBLE", "IDENTIFIER", "STRING_LITERAL",
  "ENUMERATION_CONSTANT", "FUNC_NAME", "GENERIC", "INT_CONST",
  "I_CONSTANT", "FLOAT_CONST", "F_CONSTANT", "DOUBLE_CONST", "BOOL",
  "LE_OP", "GE_OP", "EQ_OP", "NE_OP", "AND_OP", "OR_OP", "LEFT_OP",
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
  "type_specifier_list", "type_specifier", "struct_or_union_specifier",
  "struct_or_union", "struct_declaration_list", "struct_declaration",
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
  "iteration_statement", "jump_statement", "program", "translation_unit",
  "external_declaration", "function_definition", "declaration_list", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-202)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-146)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    2775,  -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,
    -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,    71,
     -19,     1,  -202,    21,  -202,  -202,  -202,  -202,  -202,  -202,
    -202,  -202,   -36,  2903,  2903,  -202,  -202,    86,  -202,  -202,
    2903,  2903,  2903,  -202,   129,  2775,  -202,  -202,    68,    92,
    1187,  3017,  1821,  -202,    24,    23,  -202,   -16,  -202,  1130,
     -51,    80,  -202,  -202,  -202,    79,   450,  -202,  -202,  -202,
    -202,  -202,    92,  -202,    75,   122,  -202,  1859,  1899,  1899,
      88,  -202,  -202,  -202,  -202,    99,  -202,  -202,  1187,  -202,
    -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,    13,
    -202,  1821,  -202,   131,   -60,    11,   -20,   -26,    95,    93,
     115,   130,   -32,  -202,   144,  3017,    91,  3017,   148,   154,
     159,   164,  -202,  -202,  -202,    23,    24,  -202,   603,  1585,
    -202,   -36,  -202,  2400,  2627,  1253,   -51,   450,  2262,  -202,
     106,  -202,   126,  1821,   -33,  -202,  1187,  -202,  1187,  -202,
    -202,  3017,  1821,   197,  -202,  -202,   112,   178,   150,  -202,
    -202,  1623,  1821,   201,  -202,  1821,  1821,  1821,  1821,  1821,
    1821,  1821,  1821,  1821,  1821,  1821,  1821,  1821,  1821,  1821,
    1821,  1821,  1821,  1821,  -202,  -202,  2185,  1293,    96,  -202,
     111,  -202,  -202,  -202,   202,  -202,  -202,  -202,  -202,   171,
    1821,   183,  1937,  1977,  2015,   991,   821,   220,   181,   199,
     484,   203,  -202,  -202,    34,  -202,  -202,  -202,  -202,   723,
    -202,  -202,  -202,  -202,  -202,  1585,  -202,  -202,  -202,  -202,
    -202,  -202,    12,   213,   216,  -202,   162,  1545,  -202,   227,
     229,  1359,  2319,  -202,  -202,  1821,  -202,    51,  -202,   225,
      22,  -202,  -202,  -202,  -202,   243,   255,   262,   263,  -202,
    -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,
    1821,  -202,  1821,  1664,  -202,  -202,   176,  -202,   149,  -202,
    -202,  -202,  -202,   131,   131,   -60,   -60,    11,    11,    11,
      11,   -20,   -20,   -26,    95,    93,   115,   130,   195,  -202,
     269,   276,  1545,  -202,   281,   288,  1399,   111,  2701,  1465,
     280,   291,   991,  1187,    61,  1187,    61,  1187,    61,   342,
     919,  1034,  1034,   273,  -202,  -202,  -202,    62,   991,  -202,
    -202,  -202,  -202,   136,  2102,  -202,   121,  -202,  -202,  2839,
    -202,   317,   294,  1545,  -202,  -202,  1821,  -202,   297,   298,
    -202,  -202,    66,  -202,  1821,  -202,   299,   299,  -202,  2960,
    -202,  -202,  1585,  -202,  -202,  1821,  -202,  1821,  -202,  -202,
     302,  1545,  -202,  -202,  1821,  -202,   303,  -202,   308,  1545,
    -202,   305,   307,  1505,   290,   991,  -202,   215,   364,   223,
    -202,   241,  -202,   316,   -67,  1034,  2550,  2480,  1034,  1702,
     226,  -202,  -202,  -202,   309,  -202,  -202,  -202,  -202,  -202,
     314,   318,  -202,  -202,  -202,  -202,   321,   249,  -202,   323,
     140,  -202,  -202,  -202,   322,   324,  -202,  -202,   330,  1545,
    -202,  -202,  1821,  -202,   331,  -202,  -202,   991,   332,   991,
     991,  1821,  1742,  1780,    61,  -202,  -202,   332,  -202,  -202,
    -202,  1821,  -202,  2960,  1821,   320,  -202,  -202,  -202,  -202,
     333,   335,  -202,   386,  -202,  -202,  -202,   252,   991,   260,
     991,   267,  -202,  -202,  -202,  -202,  -202,  -202,  -202,  -202,
     991,   319,  -202,   991,  -202,   991,  -202,  -202,  -202,  -202
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
       0,   131,   108,   109,   110,   112,   113,   165,   161,   162,
     163,   117,   118,   120,   123,   124,   116,   126,   127,     0,
       0,   164,   166,     0,   111,   119,   121,   135,   136,   122,
     125,   274,     0,    95,    97,   115,   129,     0,   130,   128,
      99,   101,   103,    93,     0,   270,   271,   273,   155,     0,
       0,     0,     0,   171,     0,   188,    91,     0,   104,   107,
     170,     0,    94,    96,   114,   134,     0,    98,   100,   102,
       1,   272,     0,    10,   159,     0,   156,     0,     0,     0,
       0,     2,    11,     9,    12,     0,     7,     8,     0,    37,
      38,    39,    40,    41,    42,    18,     3,     4,     6,    30,
      43,     0,    45,    49,    52,    55,    60,    63,    65,    67,
      69,    71,    73,    90,     0,   143,   201,   145,     0,     0,
       0,     0,   164,   189,   187,   186,     0,    92,     0,     0,
     277,     0,   276,     0,     0,     0,   169,     0,     0,   137,
       0,   141,     0,     0,     0,   151,     0,    34,     0,    31,
      32,     0,     0,    43,    75,    88,     0,     0,     0,    24,
      25,     0,     0,     0,    33,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   168,   142,     0,     0,   203,   200,
     204,   144,   167,   160,     0,   172,   190,   185,   105,   107,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     2,   240,   246,     0,   244,   245,   231,   232,     0,
     242,   233,   234,   235,   236,     0,   228,   106,   278,   275,
     198,   183,   197,     0,   192,   193,     0,     0,   173,    38,
       0,     0,     0,   132,   138,     0,   139,     0,   146,   150,
       0,   153,   158,   152,   157,     0,     0,     0,     0,    78,
      79,    80,    81,    82,    83,    84,    85,    86,    87,    77,
       0,     5,     0,     0,    23,    20,     0,    28,     0,    22,
      46,    47,    48,    50,    51,    53,    54,    58,    59,    56,
      57,    61,    62,    64,    66,    68,    70,    72,     0,   222,
       0,     0,     0,   206,    38,     0,     0,   202,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   266,   267,   268,     0,     0,   247,
     241,   243,   229,     0,     0,   195,   203,   196,   182,     0,
     184,     0,     0,     0,   174,   181,     0,   180,    38,     0,
     133,   148,     0,   140,     0,   154,    35,     0,    36,     0,
      76,    89,     0,    44,    21,     0,    19,     0,   223,   205,
       0,     0,   207,   213,     0,   212,     0,   224,     0,     0,
     214,    38,     0,     0,     0,     0,   239,     0,   251,     0,
     253,     0,   255,     0,     0,     0,   115,    99,     0,     0,
       0,   265,   269,   237,     0,   226,   191,   194,   199,   176,
       0,     0,   177,   179,   147,   149,     0,     0,    14,     0,
       0,    29,    74,   209,     0,     0,   211,   225,     0,     0,
     215,   221,     0,   220,     0,   230,   238,     5,     0,     5,
       5,     0,     0,     0,     0,   260,   257,     0,   227,   175,
     178,     0,    13,     0,     0,     0,    26,   208,   210,   217,
       0,     0,   218,   249,   250,   252,   254,     0,     0,     0,
       0,     0,   259,   258,    17,    15,    16,    27,   216,   219,
       0,     0,   263,     0,   261,     0,   248,   256,   264,   262
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -202,  -202,  -202,  -202,  -202,  -202,  -202,   -31,  -202,  -202,
     360,  -202,   -28,   190,   191,   179,   193,   242,   244,   245,
     246,   248,  -202,   -29,   139,  -202,   -42,   -27,   -50,    29,
    -202,   306,  -202,  -202,    16,  -202,  -202,   287,  -112,   -30,
    -202,    76,  -202,   359,  -132,  -202,     0,  -202,  -202,   -21,
     -55,   -35,  -120,  -131,  -202,    94,  -202,   -49,  -108,  -178,
     311,    72,   -44,  -201,  -202,   -54,  -202,   217,  -199,  -202,
    -202,  -202,  -202,  -202,   390,  -202,  -202
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,    95,    96,    74,    97,    98,   417,   418,    99,   276,
     153,   101,   102,   103,   104,   105,   106,   107,   108,   109,
     110,   111,   112,   154,   155,   270,   214,   114,    31,   131,
      57,    58,    33,    34,   115,    36,    37,   138,   139,   116,
     247,   248,    38,    75,    76,    39,   117,    41,    42,   121,
      60,    61,   125,   300,   234,   235,   236,   157,   301,   190,
     332,   333,    43,   216,   217,   218,   219,   220,   221,   222,
     223,   224,    44,    45,    46,    47,   133
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      40,   118,   119,   233,   319,   132,   136,   322,   189,   130,
     307,    59,   254,   271,   272,   241,    35,   158,   159,   160,
     124,   113,   141,   113,    53,   120,   244,    73,   134,    32,
     168,   169,   135,    40,    40,   329,   140,     8,     9,    10,
      40,    40,    40,    54,   182,    40,   156,   176,   177,    35,
      64,   172,   173,    55,   253,   123,    35,    35,    35,    40,
      50,    35,    62,    63,   122,   126,    56,   306,   183,    67,
      68,    69,    53,   164,    32,    35,   174,   175,   215,   229,
      51,   188,    73,   228,    53,   185,   127,   191,   170,   171,
     197,   334,   161,   141,   141,   187,   162,   255,   163,   256,
      52,    55,   257,    54,   156,   199,   156,   140,   140,   355,
     199,   386,    55,    55,   113,   272,   252,   343,   254,   249,
     278,   398,   399,   400,   337,   196,    53,   403,    40,    70,
     244,    48,   352,    40,    40,   123,   329,   280,   281,   282,
      53,   298,   272,   272,    35,    54,    65,   128,   245,    35,
      35,   188,    73,   353,    72,    55,   321,    49,   307,    54,
     314,   316,   318,   232,   402,   137,    53,   151,   327,   215,
     186,   113,    66,   311,   187,   186,   143,   378,   152,   187,
      55,    53,   371,   178,   436,    54,    40,   123,   245,   383,
     308,   179,   271,   272,   309,    55,   442,   336,   141,   443,
     334,   447,    35,   144,   187,   181,    40,   250,   246,   145,
     274,   335,   140,   251,   180,   232,   113,   404,   351,    40,
     165,   455,    35,   405,   184,   166,   167,   456,   192,    77,
     272,    78,    79,   366,   193,    35,   463,   123,   465,   466,
     194,   196,   340,   341,   195,   363,   259,   260,   261,   262,
     263,   264,   265,   266,   267,   268,   364,   365,   273,   429,
     388,   279,   390,   310,   392,   312,    80,   482,   226,   484,
     395,   387,   129,   389,   240,   391,   272,   367,   394,   486,
     323,   136,   488,   324,   489,   328,    81,    82,    83,    84,
      85,   258,    86,   338,    87,   437,   272,   339,   269,   336,
     277,   325,   123,   439,   272,    88,   196,   354,    40,   123,
     419,   344,   128,   345,    89,    90,    91,    92,    93,    94,
     397,   440,   272,   356,    35,   113,   305,   415,   213,   452,
     453,   249,   481,   272,    40,   357,   396,   232,   422,    40,
     483,   272,   358,   196,   359,   445,   446,   485,   272,   368,
      35,   287,   288,   289,   290,    35,   369,   444,   283,   284,
     384,   285,   286,   232,   226,   372,   185,   191,   232,   291,
     292,   196,   373,   385,   393,   401,   342,   408,   409,   123,
     349,   412,   413,   196,   464,   362,   423,   426,   427,   430,
     472,   431,   435,   473,   438,   441,   448,   397,   449,   467,
     469,   471,   450,   451,   419,   454,   457,   477,   458,   360,
     100,   361,   100,   396,   459,   462,   480,   478,   128,   479,
     293,   487,   475,   294,   242,   295,    67,   296,   414,   196,
     297,   142,   198,   407,   420,    71,   331,   147,   149,   150,
     227,   370,     0,     0,     0,   376,     0,     0,   382,     0,
       0,     0,     0,     0,     0,     0,     0,     1,     0,     0,
       0,   100,     0,     0,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,     0,     0,     0,     0,
       0,     0,   410,     0,     0,   411,     0,    77,     0,    78,
      79,    21,     0,    23,     0,    25,    26,    27,    28,     0,
       0,   226,     0,   100,   421,     0,     0,     0,     0,    29,
     424,     0,     0,   425,     0,     0,     0,     0,   428,     0,
      30,     0,   434,     0,    80,   100,   100,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   100,     0,    81,    82,    83,    84,    85,     0,
      86,     0,    87,     0,     0,     0,     0,     0,     0,     0,
     100,     0,     0,    88,     0,     0,     0,     0,   460,     0,
       0,   461,    89,    90,    91,    92,    93,    94,     0,     0,
       0,     0,     0,     0,     0,     0,   326,     0,     0,     0,
     474,     0,     0,   476,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   100,    77,     0,    78,    79,
       1,     2,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,     0,
     200,   201,   202,   100,   203,   204,   205,   206,   207,   208,
     209,   210,    20,    80,    21,    22,    23,    24,    25,    26,
      27,    28,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    29,   211,    82,    83,    84,    85,     0,    86,
       0,    87,     0,    30,     0,     0,     0,     0,     0,     0,
       0,     0,    88,     0,     0,     0,     0,     0,     0,   128,
     212,    89,    90,    91,    92,    93,    94,     0,     0,     0,
       0,     0,     0,     0,     0,   213,     0,     0,     0,     0,
       0,     0,     0,     0,   100,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    77,   100,    78,    79,
       1,     2,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,     0,
     200,   201,   202,     0,   203,   204,   205,   206,   207,   208,
     209,   210,    20,    80,    21,    22,    23,    24,    25,    26,
      27,    28,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    29,   211,    82,    83,    84,    85,     0,    86,
       0,    87,     0,    30,     0,     0,     0,     0,     0,     0,
       0,     0,    88,     0,     0,     0,     0,     0,     0,   128,
     330,    89,    90,    91,    92,    93,    94,     0,     0,     0,
       0,     0,     0,     0,    77,   213,    78,    79,     1,     2,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      20,    80,    21,    22,    23,    24,    25,    26,    27,    28,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      29,    81,    82,    83,    84,    85,     0,    86,     0,    87,
       0,    30,     0,     0,     0,     0,     0,     0,     0,     0,
     320,     0,     0,     0,     0,     0,     0,     0,     0,    89,
      90,    91,    92,    93,    94,     0,     0,     0,     0,     0,
       0,     0,    77,   213,    78,    79,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    20,    80,
      21,    22,    23,    24,    25,    26,    27,    28,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    29,    81,
      82,    83,    84,    85,     0,    86,     0,    87,     0,    30,
       0,     0,     0,     0,    77,     0,    78,    79,    88,     0,
       0,     0,     0,     0,     0,     0,     0,    89,    90,    91,
      92,    93,    94,     0,     0,     0,     0,     0,   200,   201,
     202,   213,   203,   204,   205,   206,   207,   208,   209,   210,
       0,    80,     0,     0,     0,     0,     0,    77,     0,    78,
      79,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   211,    82,    83,    84,    85,     0,    86,     0,    87,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      88,     0,     0,     0,    80,     0,     0,   128,     0,    89,
      90,    91,    92,    93,    94,     0,     0,     0,     0,     0,
       0,     0,     0,   213,    81,    82,    83,    84,    85,     0,
      86,     0,    87,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    88,     0,     0,     0,     0,     0,     0,
       0,     0,    89,    90,    91,    92,    93,    94,     0,     0,
       0,     0,     0,     0,     0,     0,   213,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    20,
       0,    21,    22,    23,    24,    25,    26,    27,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    29,
      77,     0,    78,    79,     1,     0,     0,     0,     0,     0,
      30,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,     0,     0,     0,   128,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    80,    21,     0,
       0,   129,    25,    26,    27,    28,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    29,    81,    82,    83,
      84,    85,     0,    86,     0,    87,    77,    30,    78,    79,
       0,     0,     0,   237,     0,     0,    88,     8,     9,    10,
       0,     0,     0,     0,     0,    89,    90,    91,    92,    93,
      94,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    80,   122,     0,    77,     0,    78,    79,
       0,     0,     0,   302,     0,     0,     0,     8,     9,    10,
       0,     0,     0,    81,    82,    83,    84,    85,     0,    86,
       0,    87,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    88,    80,   122,     0,     0,   238,     0,     0,
       0,    89,   239,    91,    92,    93,    94,     0,     0,     0,
       0,     0,     0,    81,    82,    83,    84,    85,     0,    86,
       0,    87,    77,     0,    78,    79,     0,     0,     0,   346,
       0,     0,    88,     8,     9,    10,     0,   303,     0,     0,
       0,    89,   304,    91,    92,    93,    94,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    80,
     122,     0,    77,     0,    78,    79,     0,     0,     0,   374,
       0,     0,     0,     8,     9,    10,     0,     0,     0,    81,
      82,    83,    84,    85,     0,    86,     0,    87,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    88,    80,
     122,     0,     0,   347,     0,     0,     0,    89,   348,    91,
      92,    93,    94,     0,     0,     0,     0,     0,     0,    81,
      82,    83,    84,    85,     0,    86,     0,    87,    77,     0,
      78,    79,     0,     0,     0,   379,     0,     0,    88,     8,
       9,    10,     0,   375,     0,     0,     0,    89,    90,    91,
      92,    93,    94,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    80,   122,     0,    77,     0,
      78,    79,     0,     0,     0,   432,     0,     0,     0,     8,
       9,    10,     0,     0,     0,    81,    82,    83,    84,    85,
       0,    86,     0,    87,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    88,    80,   122,     0,    77,   380,
      78,    79,     0,    89,   381,    91,    92,    93,    94,     8,
       9,    10,     0,     0,     0,    81,    82,    83,    84,    85,
       0,    86,     0,    87,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    88,    80,   122,     0,    77,   433,
      78,    79,     0,    89,    90,    91,    92,    93,    94,     0,
       0,     0,     0,     0,     0,    81,    82,    83,    84,    85,
       0,    86,     0,    87,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    88,    80,    77,     0,    78,    79,
       0,     0,     0,    89,    90,    91,    92,    93,    94,     0,
       0,     0,     0,     0,     0,    81,    82,    83,    84,    85,
       0,    86,     0,    87,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    80,    88,     0,     0,    77,     0,    78,
      79,   225,     0,    89,    90,    91,    92,    93,    94,     0,
       0,     0,     0,    81,    82,    83,    84,    85,     0,    86,
       0,    87,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    88,   275,    80,    77,     0,    78,    79,     0,
       0,    89,    90,    91,    92,    93,    94,     0,     0,     0,
       0,     0,     0,     0,    81,    82,    83,    84,    85,     0,
      86,     0,    87,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    80,    88,     0,    77,     0,    78,    79,     0,
     362,     0,    89,    90,    91,    92,    93,    94,     0,     0,
       0,     0,    81,    82,    83,    84,    85,     0,    86,     0,
      87,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    88,    80,    77,     0,    78,    79,     0,   128,     0,
      89,    90,    91,    92,    93,    94,     0,     0,     0,     0,
       0,     0,    81,    82,    83,    84,    85,     0,    86,     0,
      87,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      80,    88,   468,     0,    77,     0,    78,    79,     0,     0,
      89,    90,    91,    92,    93,    94,     0,     0,     0,     0,
      81,    82,    83,    84,    85,     0,    86,     0,    87,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    88,
     470,    80,    77,     0,    78,    79,     0,     0,    89,    90,
      91,    92,    93,    94,     0,     0,     0,     0,     0,     0,
       0,    81,    82,    83,    84,    85,     0,    86,     0,    87,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    80,
      88,     0,    77,     0,    78,    79,     0,     0,     0,    89,
      90,    91,    92,    93,    94,     0,     0,     0,     0,    81,
      82,    83,    84,    85,     0,    86,     0,    87,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   146,    80,
      77,     0,    78,    79,     0,     0,     0,    89,    90,    91,
      92,    93,    94,     0,     0,     0,     0,     0,     0,    81,
      82,    83,    84,    85,     0,    86,     0,    87,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    80,   148,     0,
      77,     0,    78,    79,     0,     0,     0,    89,    90,    91,
      92,    93,    94,     0,     0,     0,     0,    81,    82,    83,
      84,    85,     0,    86,     0,    87,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   313,    80,    77,     0,
      78,    79,     0,     0,     0,    89,    90,    91,    92,    93,
      94,     0,     0,     0,     0,     0,     0,    81,    82,    83,
      84,    85,     0,    86,     0,    87,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    80,   315,     0,     0,     0,
       0,     0,     0,     0,     0,    89,    90,    91,    92,    93,
      94,     0,     0,     0,     0,    81,    82,    83,    84,    85,
       0,    86,     0,    87,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   317,     0,     0,     0,     0,     0,
       0,     0,     0,    89,    90,    91,    92,    93,    94,     1,
       2,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    20,     0,    21,    22,     0,    24,    25,    26,    27,
      28,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    29,    53,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    30,     0,     0,     0,     0,     0,     0,     0,
       0,   334,   299,     0,     0,   187,     0,     0,     0,     0,
       0,    55,     1,     2,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    20,     0,    21,    22,     0,    24,
      25,    26,    27,    28,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    29,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    30,     0,     0,     0,     0,
       0,     0,     0,     0,   186,   299,     0,     0,   187,     1,
       0,     0,     0,     0,    55,     0,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    21,     0,    23,     0,    25,    26,    27,
      28,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    29,     0,     0,     0,     0,     1,     0,     0,     0,
       0,     0,    30,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,     0,     0,     0,     0,   243,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      21,     0,    23,     0,    25,    26,    27,    28,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    29,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    30,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   350,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    20,
       0,    21,    22,    23,    24,    25,    26,    27,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    29,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      30,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   128,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    20,
       0,    21,    22,     0,    24,    25,    26,    27,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    29,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      30,     0,     0,     0,     0,     0,     0,     1,     0,     0,
    -145,     0,     0,  -145,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    21,     0,     0,     0,    25,    26,    27,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    29,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      30,     0,     0,     0,     0,     0,     0,     0,     0,     0,
    -143,     0,     0,  -143,     1,     2,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    20,     0,    21,    22,
       0,    24,    25,    26,    27,    28,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    29,   230,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    30,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   231,     1,     2,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      20,     0,    21,    22,     0,    24,    25,    26,    27,    28,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      29,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    30,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   377,     1,     2,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    20,     0,    21,    22,    23,    24,
      25,    26,    27,    28,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    29,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    30,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,   406,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    20,     0,
      21,    22,     0,    24,    25,    26,    27,    28,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    29,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    30,
       1,     2,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    20,     0,    21,    22,     0,    24,    25,    26,
      27,    28,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    29,     0,     0,     0,     0,     1,     0,     0,
       0,     0,     0,    30,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,     0,     0,   416,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    21,     0,     0,     0,    25,    26,    27,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    29,
       0,     0,     0,     0,     1,     0,     0,     0,     0,     0,
      30,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    21,     0,
       0,     0,    25,    26,    27,    28,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    29,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    30
};

static const yytype_int16 yycheck[] =
{
       0,    50,    51,   134,   205,    59,    61,   206,   116,    59,
     188,    32,   144,    80,    81,   135,     0,     4,     5,     6,
      55,    50,    66,    52,    60,    52,   138,    60,    79,     0,
      90,    91,    83,    33,    34,   102,    66,    14,    15,    16,
      40,    41,    42,    79,    76,    45,    88,    73,    74,    33,
      34,    71,    72,    89,    87,    55,    40,    41,    42,    59,
      79,    45,    33,    34,    41,    81,   102,   187,   100,    40,
      41,    42,    60,   101,    45,    59,    96,    97,   128,   133,
      79,   116,    60,   133,    60,   115,   102,   117,    77,    78,
     125,    79,    79,   137,   138,    83,    83,   146,    85,   148,
      79,    89,   151,    79,   146,   126,   148,   137,   138,    87,
     131,   312,    89,    89,   143,    81,   143,   237,   250,   140,
     162,   320,   321,   322,   232,   125,    60,   328,   128,     0,
     242,    60,    81,   133,   134,   135,   102,   165,   166,   167,
      60,   183,    81,    81,   128,    79,    60,    86,    82,   133,
     134,   186,    60,   102,    86,    89,   206,    86,   336,    79,
     202,   203,   204,   134,   102,    86,    60,    79,   210,   219,
      79,   200,    86,   200,    83,    79,   101,   308,    79,    83,
      89,    60,   302,    88,   385,    79,   186,   187,    82,   309,
      79,    98,    80,    81,    83,    89,   395,   232,   242,   398,
      79,   400,   186,    81,    83,    75,   206,    81,   102,    87,
      60,   232,   242,    87,    99,   186,   245,    81,   245,   219,
      89,    81,   206,    87,    80,    94,    95,    87,    80,     3,
      81,     5,     6,    84,    80,   219,   437,   237,   439,   440,
      81,   241,    80,    81,    80,   273,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    80,    81,    80,   379,
     314,    60,   316,    61,   318,    82,    40,   468,   129,   470,
     320,   313,   101,   315,   135,   317,    81,    82,   320,   480,
      60,   336,   483,   102,   485,    82,    60,    61,    62,    63,
      64,   152,    66,    80,    68,    80,    81,    81,   101,   334,
     161,   102,   302,    80,    81,    79,   306,    82,   308,   309,
     359,    84,    86,    84,    88,    89,    90,    91,    92,    93,
     320,    80,    81,    80,   308,   354,   187,   354,   102,    80,
      81,   352,    80,    81,   334,    80,   320,   308,   367,   339,
      80,    81,    80,   343,    81,   399,   400,    80,    81,    80,
     334,   172,   173,   174,   175,   339,    80,   399,   168,   169,
      80,   170,   171,   334,   225,    84,   396,   397,   339,   176,
     177,   371,    84,    82,    32,   102,   237,    60,    84,   379,
     241,    84,    84,   383,   438,    86,    84,    84,    80,    84,
     444,    84,   102,   447,    30,    79,    87,   397,    84,   441,
     442,   443,    84,    82,   453,    82,    84,    87,    84,   270,
      50,   272,    52,   397,    84,    84,    30,    84,    86,    84,
     178,   102,   453,   179,   137,   180,   397,   181,   352,   429,
     182,    72,   126,   339,   362,    45,   219,    77,    78,    79,
     129,   302,    -1,    -1,    -1,   306,    -1,    -1,   309,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     7,    -1,    -1,
      -1,   101,    -1,    -1,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    -1,    -1,    -1,    -1,
      -1,    -1,   343,    -1,    -1,   346,    -1,     3,    -1,     5,
       6,    41,    -1,    43,    -1,    45,    46,    47,    48,    -1,
      -1,   362,    -1,   143,   365,    -1,    -1,    -1,    -1,    59,
     371,    -1,    -1,   374,    -1,    -1,    -1,    -1,   379,    -1,
      70,    -1,   383,    -1,    40,   165,   166,   167,   168,   169,
     170,   171,   172,   173,   174,   175,   176,   177,   178,   179,
     180,   181,   182,    -1,    60,    61,    62,    63,    64,    -1,
      66,    -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     200,    -1,    -1,    79,    -1,    -1,    -1,    -1,   429,    -1,
      -1,   432,    88,    89,    90,    91,    92,    93,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   102,    -1,    -1,    -1,
     451,    -1,    -1,   454,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   245,     3,    -1,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,    21,    22,    23,    24,    25,    -1,
      27,    28,    29,   273,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    59,    60,    61,    62,    63,    64,    -1,    66,
      -1,    68,    -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,    -1,    86,
      87,    88,    89,    90,    91,    92,    93,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   102,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   354,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,     3,   367,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,    21,    22,    23,    24,    25,    -1,
      27,    28,    29,    -1,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    59,    60,    61,    62,    63,    64,    -1,    66,
      -1,    68,    -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,    -1,    86,
      87,    88,    89,    90,    91,    92,    93,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,     3,   102,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,    21,    22,    23,    24,    25,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      59,    60,    61,    62,    63,    64,    -1,    66,    -1,    68,
      -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      79,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    88,
      89,    90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,     3,   102,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    25,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,    60,
      61,    62,    63,    64,    -1,    66,    -1,    68,    -1,    70,
      -1,    -1,    -1,    -1,     3,    -1,     5,     6,    79,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    88,    89,    90,
      91,    92,    93,    -1,    -1,    -1,    -1,    -1,    27,    28,
      29,   102,    31,    32,    33,    34,    35,    36,    37,    38,
      -1,    40,    -1,    -1,    -1,    -1,    -1,     3,    -1,     5,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    60,    61,    62,    63,    64,    -1,    66,    -1,    68,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      79,    -1,    -1,    -1,    40,    -1,    -1,    86,    -1,    88,
      89,    90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   102,    60,    61,    62,    63,    64,    -1,
      66,    -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    88,    89,    90,    91,    92,    93,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   102,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    39,
      -1,    41,    42,    43,    44,    45,    46,    47,    48,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,
       3,    -1,     5,     6,     7,    -1,    -1,    -1,    -1,    -1,
      70,    14,    15,    16,    17,    18,    19,    20,    21,    22,
      23,    24,    25,    -1,    -1,    -1,    86,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,    41,    -1,
      -1,   101,    45,    46,    47,    48,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    59,    60,    61,    62,
      63,    64,    -1,    66,    -1,    68,     3,    70,     5,     6,
      -1,    -1,    -1,    10,    -1,    -1,    79,    14,    15,    16,
      -1,    -1,    -1,    -1,    -1,    88,    89,    90,    91,    92,
      93,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    40,    41,    -1,     3,    -1,     5,     6,
      -1,    -1,    -1,    10,    -1,    -1,    -1,    14,    15,    16,
      -1,    -1,    -1,    60,    61,    62,    63,    64,    -1,    66,
      -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    79,    40,    41,    -1,    -1,    84,    -1,    -1,
      -1,    88,    89,    90,    91,    92,    93,    -1,    -1,    -1,
      -1,    -1,    -1,    60,    61,    62,    63,    64,    -1,    66,
      -1,    68,     3,    -1,     5,     6,    -1,    -1,    -1,    10,
      -1,    -1,    79,    14,    15,    16,    -1,    84,    -1,    -1,
      -1,    88,    89,    90,    91,    92,    93,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,
      41,    -1,     3,    -1,     5,     6,    -1,    -1,    -1,    10,
      -1,    -1,    -1,    14,    15,    16,    -1,    -1,    -1,    60,
      61,    62,    63,    64,    -1,    66,    -1,    68,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,    40,
      41,    -1,    -1,    84,    -1,    -1,    -1,    88,    89,    90,
      91,    92,    93,    -1,    -1,    -1,    -1,    -1,    -1,    60,
      61,    62,    63,    64,    -1,    66,    -1,    68,     3,    -1,
       5,     6,    -1,    -1,    -1,    10,    -1,    -1,    79,    14,
      15,    16,    -1,    84,    -1,    -1,    -1,    88,    89,    90,
      91,    92,    93,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    40,    41,    -1,     3,    -1,
       5,     6,    -1,    -1,    -1,    10,    -1,    -1,    -1,    14,
      15,    16,    -1,    -1,    -1,    60,    61,    62,    63,    64,
      -1,    66,    -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    79,    40,    41,    -1,     3,    84,
       5,     6,    -1,    88,    89,    90,    91,    92,    93,    14,
      15,    16,    -1,    -1,    -1,    60,    61,    62,    63,    64,
      -1,    66,    -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    79,    40,    41,    -1,     3,    84,
       5,     6,    -1,    88,    89,    90,    91,    92,    93,    -1,
      -1,    -1,    -1,    -1,    -1,    60,    61,    62,    63,    64,
      -1,    66,    -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    79,    40,     3,    -1,     5,     6,
      -1,    -1,    -1,    88,    89,    90,    91,    92,    93,    -1,
      -1,    -1,    -1,    -1,    -1,    60,    61,    62,    63,    64,
      -1,    66,    -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    40,    79,    -1,    -1,     3,    -1,     5,
       6,    86,    -1,    88,    89,    90,    91,    92,    93,    -1,
      -1,    -1,    -1,    60,    61,    62,    63,    64,    -1,    66,
      -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    79,    80,    40,     3,    -1,     5,     6,    -1,
      -1,    88,    89,    90,    91,    92,    93,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    60,    61,    62,    63,    64,    -1,
      66,    -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    40,    79,    -1,     3,    -1,     5,     6,    -1,
      86,    -1,    88,    89,    90,    91,    92,    93,    -1,    -1,
      -1,    -1,    60,    61,    62,    63,    64,    -1,    66,    -1,
      68,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    79,    40,     3,    -1,     5,     6,    -1,    86,    -1,
      88,    89,    90,    91,    92,    93,    -1,    -1,    -1,    -1,
      -1,    -1,    60,    61,    62,    63,    64,    -1,    66,    -1,
      68,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      40,    79,    80,    -1,     3,    -1,     5,     6,    -1,    -1,
      88,    89,    90,    91,    92,    93,    -1,    -1,    -1,    -1,
      60,    61,    62,    63,    64,    -1,    66,    -1,    68,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,
      80,    40,     3,    -1,     5,     6,    -1,    -1,    88,    89,
      90,    91,    92,    93,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    60,    61,    62,    63,    64,    -1,    66,    -1,    68,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,
      79,    -1,     3,    -1,     5,     6,    -1,    -1,    -1,    88,
      89,    90,    91,    92,    93,    -1,    -1,    -1,    -1,    60,
      61,    62,    63,    64,    -1,    66,    -1,    68,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,    40,
       3,    -1,     5,     6,    -1,    -1,    -1,    88,    89,    90,
      91,    92,    93,    -1,    -1,    -1,    -1,    -1,    -1,    60,
      61,    62,    63,    64,    -1,    66,    -1,    68,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,    79,    -1,
       3,    -1,     5,     6,    -1,    -1,    -1,    88,    89,    90,
      91,    92,    93,    -1,    -1,    -1,    -1,    60,    61,    62,
      63,    64,    -1,    66,    -1,    68,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    79,    40,     3,    -1,
       5,     6,    -1,    -1,    -1,    88,    89,    90,    91,    92,
      93,    -1,    -1,    -1,    -1,    -1,    -1,    60,    61,    62,
      63,    64,    -1,    66,    -1,    68,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    40,    79,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    88,    89,    90,    91,    92,
      93,    -1,    -1,    -1,    -1,    60,    61,    62,    63,    64,
      -1,    66,    -1,    68,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    88,    89,    90,    91,    92,    93,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    39,    -1,    41,    42,    -1,    44,    45,    46,    47,
      48,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    59,    60,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    79,    80,    -1,    -1,    83,    -1,    -1,    -1,    -1,
      -1,    89,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    39,    -1,    41,    42,    -1,    44,
      45,    46,    47,    48,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    59,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    70,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    79,    80,    -1,    -1,    83,     7,
      -1,    -1,    -1,    -1,    89,    -1,    14,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    41,    -1,    43,    -1,    45,    46,    47,
      48,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    59,    -1,    -1,    -1,    -1,     7,    -1,    -1,    -1,
      -1,    -1,    70,    14,    15,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    25,    -1,    -1,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      41,    -1,    43,    -1,    45,    46,    47,    48,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    70,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    87,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    39,
      -1,    41,    42,    43,    44,    45,    46,    47,    48,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    86,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    39,
      -1,    41,    42,    -1,    44,    45,    46,    47,    48,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      70,    -1,    -1,    -1,    -1,    -1,    -1,     7,    -1,    -1,
      80,    -1,    -1,    83,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    41,    -1,    -1,    -1,    45,    46,    47,    48,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      80,    -1,    -1,    83,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,    21,    22,
      23,    24,    25,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    39,    -1,    41,    42,
      -1,    44,    45,    46,    47,    48,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    59,    60,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    70,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,    21,    22,    23,    24,    25,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      39,    -1,    41,    42,    -1,    44,    45,    46,    47,    48,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      59,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    80,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    39,    -1,    41,    42,    43,    44,
      45,    46,    47,    48,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    59,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    70,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    39,    -1,
      41,    42,    -1,    44,    45,    46,    47,    48,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    70,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,    21,    22,    23,    24,    25,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    39,    -1,    41,    42,    -1,    44,    45,    46,
      47,    48,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    59,    -1,    -1,    -1,    -1,     7,    -1,    -1,
      -1,    -1,    -1,    70,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    -1,    -1,    28,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    41,    -1,    -1,    -1,    45,    46,    47,    48,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    59,
      -1,    -1,    -1,    -1,     7,    -1,    -1,    -1,    -1,    -1,
      70,    14,    15,    16,    17,    18,    19,    20,    21,    22,
      23,    24,    25,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    41,    -1,
      -1,    -1,    45,    46,    47,    48,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    59,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    70
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      39,    41,    42,    43,    44,    45,    46,    47,    48,    59,
      70,   131,   132,   135,   136,   137,   138,   139,   145,   148,
     149,   150,   151,   165,   175,   176,   177,   178,    60,    86,
      79,    79,    79,    60,    79,    89,   102,   133,   134,   152,
     153,   154,   132,   132,   137,    60,    86,   132,   132,   132,
       0,   177,    86,    60,   106,   146,   147,     3,     5,     6,
      40,    60,    61,    62,    63,    64,    66,    68,    79,    88,
      89,    90,    91,    92,    93,   104,   105,   107,   108,   111,
     113,   114,   115,   116,   117,   118,   119,   120,   121,   122,
     123,   124,   125,   126,   130,   137,   142,   149,   160,   160,
     130,   152,    41,   149,   154,   155,    81,   102,    86,   101,
     131,   132,   168,   179,    79,    83,   153,    86,   140,   141,
     142,   165,   146,   101,    81,    87,    79,   113,    79,   113,
     113,    79,    79,   113,   126,   127,   129,   160,     4,     5,
       6,    79,    83,    85,   115,    89,    94,    95,    90,    91,
      77,    78,    71,    72,    96,    97,    73,    74,    88,    98,
      99,    75,    76,   100,    80,   142,    79,    83,   154,   161,
     162,   142,    80,    80,    81,    80,   149,   154,   134,   152,
      27,    28,    29,    31,    32,    33,    34,    35,    36,    37,
      38,    60,    87,   102,   129,   131,   166,   167,   168,   169,
     170,   171,   172,   173,   174,    86,   127,   163,   131,   168,
      60,    80,   132,   156,   157,   158,   159,    10,    84,    89,
     127,   155,   140,    87,   141,    82,   102,   143,   144,   152,
      81,    87,   130,    87,   147,   160,   160,   160,   127,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,   101,
     128,    80,    81,    80,    60,    80,   112,   127,   129,    60,
     115,   115,   115,   116,   116,   117,   117,   118,   118,   118,
     118,   119,   119,   120,   121,   122,   123,   124,   129,    80,
     156,   161,    10,    84,    89,   127,   155,   162,    79,    83,
      61,   130,    82,    79,   129,    79,   129,    79,   129,   166,
      79,   131,   171,    60,   102,   102,   102,   129,    82,   102,
      87,   170,   163,   164,    79,   152,   154,   161,    80,    81,
      80,    81,   127,   155,    84,    84,    10,    84,    89,   127,
      87,   130,    81,   102,    82,    87,    80,    80,    80,    81,
     127,   127,    86,   115,    80,    81,    84,    82,    80,    80,
     127,   155,    84,    84,    10,    84,   127,    80,   156,    10,
      84,    89,   127,   155,    80,    82,   166,   129,   168,   129,
     168,   129,   168,    32,   129,   131,   137,   149,   171,   171,
     171,   102,   102,   166,    81,    87,    26,   158,    60,    84,
     127,   127,    84,    84,   144,   130,    28,   109,   110,   160,
     164,   127,   126,    84,   127,   127,    84,    80,   127,   155,
      84,    84,    10,    84,   127,   102,   166,    80,    30,    80,
      80,    79,   171,   171,   129,   168,   168,   171,    87,    84,
      84,    82,    80,    81,    82,    81,    87,    84,    84,    84,
     127,   127,    84,   166,   168,   166,   166,   129,    80,   129,
      80,   129,   168,   168,   127,   110,   127,    87,    84,    84,
      30,    80,   166,    80,   166,    80,   166,   102,   166,   166
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
     135,   135,   135,   135,   136,   136,   137,   137,   137,   137,
     137,   137,   137,   137,   137,   137,   137,   137,   137,   137,
     137,   137,   138,   138,   138,   139,   139,   140,   140,   141,
     141,   141,   142,   142,   142,   142,   143,   143,   144,   144,
     144,   145,   145,   145,   145,   145,   146,   146,   147,   147,
     148,   149,   149,   149,   149,   150,   150,   151,   151,   152,
     152,   153,   153,   153,   153,   153,   153,   153,   153,   153,
     153,   153,   153,   153,   153,   154,   154,   154,   154,   155,
     155,   156,   156,   157,   157,   158,   158,   158,   159,   159,
     160,   160,   161,   161,   161,   162,   162,   162,   162,   162,
     162,   162,   162,   162,   162,   162,   162,   162,   162,   162,
     162,   162,   162,   162,   162,   162,   163,   163,   163,   164,
     165,   166,   166,   166,   166,   166,   166,   167,   167,   167,
     168,   168,   169,   169,   170,   170,   171,   171,   172,   172,
     172,   172,   172,   172,   173,   173,   173,   173,   173,   173,
     173,   173,   173,   173,   173,   174,   174,   174,   174,   174,
     175,   176,   176,   177,   177,   178,   178,   179,   179
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
       1,     1,     1,     1,     2,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     4,     5,     2,     1,     1,     1,     2,     2,
       3,     1,     2,     1,     2,     1,     1,     3,     2,     3,
       1,     4,     5,     5,     6,     2,     1,     3,     3,     1,
       4,     1,     1,     1,     1,     1,     1,     4,     4,     2,
       1,     1,     3,     3,     4,     6,     5,     5,     6,     5,
       4,     4,     4,     3,     4,     3,     2,     2,     1,     1,
       2,     3,     1,     1,     3,     2,     2,     1,     1,     3,
       2,     1,     2,     1,     1,     3,     2,     3,     5,     4,
       5,     4,     3,     3,     3,     4,     6,     5,     5,     6,
       4,     4,     2,     3,     3,     4,     3,     4,     1,     1,
       7,     1,     1,     1,     1,     1,     1,     3,     4,     3,
       2,     3,     1,     2,     1,     1,     1,     2,     7,     5,
       5,     3,     5,     3,     5,     3,     7,     4,     5,     5,
       4,     6,     7,     6,     7,     3,     2,     2,     2,     3,
       1,     1,     2,     1,     1,     4,     3,     1,     2
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
#line 100 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_identifier_node((yyvsp[0].id)); }
#line 2179 "c11.tab.c"
    break;

  case 5: /* primary_expression: '(' expression ')'  */
#line 103 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                             { (yyval.node) = (yyvsp[-1].node); }
#line 2185 "c11.tab.c"
    break;

  case 7: /* constant: I_CONSTANT  */
#line 108 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_constant_node((yyvsp[0].intval)); }
#line 2191 "c11.tab.c"
    break;

  case 8: /* constant: F_CONSTANT  */
#line 109 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_float_node((yyvsp[0].fval)); }
#line 2197 "c11.tab.c"
    break;

  case 9: /* constant: ENUMERATION_CONSTANT  */
#line 110 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                               { (yyval.node) = make_identifier_node((yyvsp[0].id)); }
#line 2203 "c11.tab.c"
    break;

  case 10: /* enumeration_constant: IDENTIFIER  */
#line 114 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_identifier_node((yyvsp[0].id)); }
#line 2209 "c11.tab.c"
    break;

  case 11: /* string: STRING_LITERAL  */
#line 118 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                         { (yyval.node) = make_string_node((yyvsp[0].id)); }
#line 2215 "c11.tab.c"
    break;

  case 12: /* string: FUNC_NAME  */
#line 119 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                    { (yyval.node) = make_string_node((yyvsp[0].id)); }
#line 2221 "c11.tab.c"
    break;

  case 13: /* generic_selection: GENERIC '(' assignment_expression ',' generic_assoc_list ')'  */
#line 123 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                       { zig_error(); }
#line 2227 "c11.tab.c"
    break;

  case 20: /* postfix_expression: postfix_expression '(' ')'  */
#line 139 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                     { (yyval.node) = make_function_call_node((yyvsp[-2].node), NULL); }
#line 2233 "c11.tab.c"
    break;

  case 21: /* postfix_expression: postfix_expression '(' argument_expression_list ')'  */
#line 140 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                              { (yyval.node) = make_function_call_node((yyvsp[-3].node), (yyvsp[-1].node)); }
#line 2239 "c11.tab.c"
    break;

  case 24: /* postfix_expression: postfix_expression INC_OP  */
#line 143 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { (yyval.node) = make_post_fix_node((yyvsp[-1].node), INC_OP); }
#line 2245 "c11.tab.c"
    break;

  case 25: /* postfix_expression: postfix_expression DEC_OP  */
#line 144 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                        { (yyval.node) = make_post_fix_node((yyvsp[-1].node), DEC_OP); }
#line 2251 "c11.tab.c"
    break;

  case 28: /* argument_expression_list: assignment_expression  */
#line 150 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                { (yyval.node) = append_argument_list((yyvsp[0].node), NULL); }
#line 2257 "c11.tab.c"
    break;

  case 29: /* argument_expression_list: argument_expression_list ',' assignment_expression  */
#line 151 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                             { (yyval.node) = append_argument_list((yyvsp[0].node), (yyvsp[-2].node)); }
#line 2263 "c11.tab.c"
    break;

  case 31: /* unary_expression: INC_OP unary_expression  */
#line 156 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                              { (yyval.node) = make_pre_fix_node(INC_OP, (yyvsp[0].node)); }
#line 2269 "c11.tab.c"
    break;

  case 32: /* unary_expression: DEC_OP unary_expression  */
#line 157 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                  { (yyval.node) = make_pre_fix_node(DEC_OP, (yyvsp[0].node)); }
#line 2275 "c11.tab.c"
    break;

  case 46: /* multiplicative_expression: multiplicative_expression '*' cast_expression  */
#line 180 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        { (yyval.node) = make_binary_node((yyvsp[-2].node), '*', (yyvsp[0].node));}
#line 2281 "c11.tab.c"
    break;

  case 47: /* multiplicative_expression: multiplicative_expression '/' cast_expression  */
#line 181 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        { (yyval.node) = make_binary_node((yyvsp[-2].node), '/', (yyvsp[0].node));}
#line 2287 "c11.tab.c"
    break;

  case 48: /* multiplicative_expression: multiplicative_expression '%' cast_expression  */
#line 182 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        { (yyval.node) = make_binary_node((yyvsp[-2].node), '%', (yyvsp[0].node));}
#line 2293 "c11.tab.c"
    break;

  case 50: /* additive_expression: additive_expression '+' multiplicative_expression  */
#line 187 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                            { (yyval.node) = make_binary_node((yyvsp[-2].node), '+', (yyvsp[0].node));}
#line 2299 "c11.tab.c"
    break;

  case 51: /* additive_expression: additive_expression '-' multiplicative_expression  */
#line 188 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                            { (yyval.node) = make_binary_node((yyvsp[-2].node), '-', (yyvsp[0].node));}
#line 2305 "c11.tab.c"
    break;

  case 53: /* shift_expression: shift_expression LEFT_OP additive_expression  */
#line 193 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                       { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), (yyvsp[-1].intval), (yyvsp[0].node));}
#line 2311 "c11.tab.c"
    break;

  case 54: /* shift_expression: shift_expression RIGHT_OP additive_expression  */
#line 194 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), (yyvsp[-1].intval), (yyvsp[0].node));}
#line 2317 "c11.tab.c"
    break;

  case 56: /* relational_expression: relational_expression '<' shift_expression  */
#line 199 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { (yyval.node) = make_binary_node((yyvsp[-2].node), '<', (yyvsp[0].node));}
#line 2323 "c11.tab.c"
    break;

  case 57: /* relational_expression: relational_expression '>' shift_expression  */
#line 200 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { (yyval.node) = make_binary_node((yyvsp[-2].node), '>', (yyvsp[0].node));}
#line 2329 "c11.tab.c"
    break;

  case 58: /* relational_expression: relational_expression LE_OP shift_expression  */
#line 201 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                       { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), LE_OP, (yyvsp[0].node));}
#line 2335 "c11.tab.c"
    break;

  case 59: /* relational_expression: relational_expression GE_OP shift_expression  */
#line 202 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                       { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), GE_OP, (yyvsp[0].node));}
#line 2341 "c11.tab.c"
    break;

  case 61: /* equality_expression: equality_expression EQ_OP relational_expression  */
#line 207 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                          { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), EQ_OP, (yyvsp[0].node));}
#line 2347 "c11.tab.c"
    break;

  case 62: /* equality_expression: equality_expression NE_OP relational_expression  */
#line 208 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                          { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), NE_OP, (yyvsp[0].node));}
#line 2353 "c11.tab.c"
    break;

  case 64: /* and_expression: and_expression '&' equality_expression  */
#line 213 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                 { (yyval.node) = make_binary_node((yyvsp[-2].node), '&', (yyvsp[0].node)); }
#line 2359 "c11.tab.c"
    break;

  case 66: /* exclusive_or_expression: exclusive_or_expression '^' and_expression  */
#line 218 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { (yyval.node) = make_binary_node((yyvsp[-2].node), '^', (yyvsp[0].node));}
#line 2365 "c11.tab.c"
    break;

  case 68: /* inclusive_or_expression: inclusive_or_expression '|' exclusive_or_expression  */
#line 223 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                              { (yyval.node) = make_binary_node((yyvsp[-2].node), '|', (yyvsp[0].node));}
#line 2371 "c11.tab.c"
    break;

  case 70: /* logical_and_expression: logical_and_expression AND_OP inclusive_or_expression  */
#line 228 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), AND_OP, (yyvsp[0].node));}
#line 2377 "c11.tab.c"
    break;

  case 72: /* logical_or_expression: logical_or_expression OR_OP logical_and_expression  */
#line 233 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                             { (yyval.node) = make_conditional_expression_node((yyvsp[-2].node), OR_OP, (yyvsp[0].node));}
#line 2383 "c11.tab.c"
    break;

  case 76: /* assignment_expression: unary_expression assignment_operator assignment_expression  */
#line 243 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                     { (yyval.node) = make_assignment_node((yyvsp[-2].node), (yyvsp[0].node), (yyvsp[-1].node)); }
#line 2389 "c11.tab.c"
    break;

  case 77: /* assignment_operator: '='  */
#line 247 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
              { (yyval.node) = make_assignment_op_node('='); }
#line 2395 "c11.tab.c"
    break;

  case 78: /* assignment_operator: MUL_ASSIGN  */
#line 248 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_assignment_op_node(MUL_ASSIGN); }
#line 2401 "c11.tab.c"
    break;

  case 79: /* assignment_operator: DIV_ASSIGN  */
#line 249 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_assignment_op_node(DIV_ASSIGN); }
#line 2407 "c11.tab.c"
    break;

  case 80: /* assignment_operator: MOD_ASSIGN  */
#line 250 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_assignment_op_node(MOD_ASSIGN); }
#line 2413 "c11.tab.c"
    break;

  case 81: /* assignment_operator: ADD_ASSIGN  */
#line 251 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_assignment_op_node(ADD_ASSIGN); }
#line 2419 "c11.tab.c"
    break;

  case 82: /* assignment_operator: SUB_ASSIGN  */
#line 252 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_assignment_op_node(SUB_ASSIGN); }
#line 2425 "c11.tab.c"
    break;

  case 83: /* assignment_operator: LEFT_ASSIGN  */
#line 253 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                      { (yyval.node) = make_assignment_op_node(LEFT_ASSIGN); }
#line 2431 "c11.tab.c"
    break;

  case 84: /* assignment_operator: RIGHT_ASSIGN  */
#line 254 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                       { (yyval.node) = make_assignment_op_node(RIGHT_ASSIGN); }
#line 2437 "c11.tab.c"
    break;

  case 85: /* assignment_operator: AND_ASSIGN  */
#line 255 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_assignment_op_node(AND_ASSIGN); }
#line 2443 "c11.tab.c"
    break;

  case 86: /* assignment_operator: XOR_ASSIGN  */
#line 256 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_assignment_op_node(XOR_ASSIGN); }
#line 2449 "c11.tab.c"
    break;

  case 87: /* assignment_operator: OR_ASSIGN  */
#line 257 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                    { (yyval.node) = make_assignment_op_node(OR_ASSIGN); }
#line 2455 "c11.tab.c"
    break;

  case 89: /* expression: expression ',' assignment_expression  */
#line 262 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                               { zig_error(); }
#line 2461 "c11.tab.c"
    break;

  case 91: /* declaration: declaration_specifiers ';'  */
#line 270 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                     { (yyval.node) = make_declaration_node((yyvsp[-1].node), NULL); }
#line 2467 "c11.tab.c"
    break;

  case 92: /* declaration: declaration_specifiers init_declarator_list ';'  */
#line 271 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                          { (yyval.node) = make_declaration_node((yyvsp[-2].node), (yyvsp[-1].node)); }
#line 2473 "c11.tab.c"
    break;

  case 93: /* declaration: static_assert_declaration  */
#line 272 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { zig_error(); }
#line 2479 "c11.tab.c"
    break;

  case 94: /* declaration_specifiers: storage_class_specifier declaration_specifiers  */
#line 276 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                         { zig_error(); }
#line 2485 "c11.tab.c"
    break;

  case 95: /* declaration_specifiers: storage_class_specifier  */
#line 277 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                  { zig_error(); }
#line 2491 "c11.tab.c"
    break;

  case 96: /* declaration_specifiers: type_specifier_list declaration_specifiers  */
#line 278 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { zig_error(); }
#line 2497 "c11.tab.c"
    break;

  case 98: /* declaration_specifiers: type_qualifier declaration_specifiers  */
#line 280 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                { zig_error(); }
#line 2503 "c11.tab.c"
    break;

  case 99: /* declaration_specifiers: type_qualifier  */
#line 281 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                         { zig_error(); }
#line 2509 "c11.tab.c"
    break;

  case 100: /* declaration_specifiers: function_specifier declaration_specifiers  */
#line 282 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                    { zig_error(); }
#line 2515 "c11.tab.c"
    break;

  case 101: /* declaration_specifiers: function_specifier  */
#line 283 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                             { zig_error(); }
#line 2521 "c11.tab.c"
    break;

  case 102: /* declaration_specifiers: alignment_specifier declaration_specifiers  */
#line 284 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { zig_error(); }
#line 2527 "c11.tab.c"
    break;

  case 103: /* declaration_specifiers: alignment_specifier  */
#line 285 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                              { zig_error(); }
#line 2533 "c11.tab.c"
    break;

  case 106: /* init_declarator: declarator '=' initializer  */
#line 294 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                     { (yyval.node) = make_assignment_node((yyvsp[-2].node), (yyvsp[0].node), NULL); }
#line 2539 "c11.tab.c"
    break;

  case 107: /* init_declarator: declarator  */
#line 295 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     {(yyval.node) = make_assignment_node((yyvsp[0].node), NULL, NULL); }
#line 2545 "c11.tab.c"
    break;

  case 114: /* type_specifier_list: type_specifier_list type_specifier  */
#line 308 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                         { (yyval.node) = combine_type_node((yyvsp[-1].node), (yyvsp[0].node)); }
#line 2551 "c11.tab.c"
    break;

  case 116: /* type_specifier: VOID  */
#line 313 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
               { 
        (yyval.node) = make_type_node(VOID);
    }
#line 2559 "c11.tab.c"
    break;

  case 117: /* type_specifier: CHAR  */
#line 316 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
               { 
        (yyval.node) = make_type_node(CHAR);
    }
#line 2567 "c11.tab.c"
    break;

  case 118: /* type_specifier: SHORT  */
#line 319 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                { 
        (yyval.node) = make_type_node(SHORT);
    }
#line 2575 "c11.tab.c"
    break;

  case 119: /* type_specifier: INT  */
#line 322 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
              { 
        (yyval.node) = make_type_node(INT);
    }
#line 2583 "c11.tab.c"
    break;

  case 120: /* type_specifier: LONG  */
#line 325 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
               { 
        (yyval.node) = make_type_node(LONG);
    }
#line 2591 "c11.tab.c"
    break;

  case 121: /* type_specifier: FLOAT  */
#line 328 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                { 
        (yyval.node) = make_type_node(FLOAT);
    }
#line 2599 "c11.tab.c"
    break;

  case 122: /* type_specifier: DOUBLE  */
#line 331 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                 { 
        (yyval.node) = make_type_node(DOUBLE);
    }
#line 2607 "c11.tab.c"
    break;

  case 123: /* type_specifier: SIGNED  */
#line 334 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                 { 
        (yyval.node) = make_type_node(SIGNED);
    }
#line 2615 "c11.tab.c"
    break;

  case 124: /* type_specifier: UNSIGNED  */
#line 337 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                   { 
        (yyval.node) = make_type_node(UNSIGNED);
    }
#line 2623 "c11.tab.c"
    break;

  case 125: /* type_specifier: BOOL  */
#line 340 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
               { 
        (yyval.node) = make_type_node(BOOL);
    }
#line 2631 "c11.tab.c"
    break;

  case 126: /* type_specifier: COMPLEX  */
#line 343 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                  { 
        (yyval.node) = make_type_node(COMPLEX);
    }
#line 2639 "c11.tab.c"
    break;

  case 127: /* type_specifier: IMAGINARY  */
#line 346 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                   { 
        (yyval.node) = make_type_node(IMAGINARY);
    }
#line 2647 "c11.tab.c"
    break;

  case 128: /* type_specifier: atomic_type_specifier  */
#line 349 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                { zig_error(); }
#line 2653 "c11.tab.c"
    break;

  case 130: /* type_specifier: enum_specifier  */
#line 351 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                         { zig_error(); }
#line 2659 "c11.tab.c"
    break;

  case 131: /* type_specifier: TYPEDEF_NAME  */
#line 352 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                       { zig_error(); }
#line 2665 "c11.tab.c"
    break;

  case 133: /* struct_or_union_specifier: struct_or_union IDENTIFIER '{' struct_declaration_list '}'  */
#line 357 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                     {(yyval.node) = make_struct_or_union((yyvsp[-4].node), (yyvsp[-3].id), (yyvsp[-1].node)); }
#line 2671 "c11.tab.c"
    break;

  case 134: /* struct_or_union_specifier: struct_or_union IDENTIFIER  */
#line 358 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                      { (yyval.node) = make_struct_or_union((yyvsp[-1].node), (yyvsp[0].id), NULL); }
#line 2677 "c11.tab.c"
    break;

  case 135: /* struct_or_union: STRUCT  */
#line 362 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                 { (yyval.node) = make_structunion_node(STRUCT); }
#line 2683 "c11.tab.c"
    break;

  case 136: /* struct_or_union: UNION  */
#line 363 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                { (yyval.node) = make_structunion_node(UNION); }
#line 2689 "c11.tab.c"
    break;

  case 137: /* struct_declaration_list: struct_declaration  */
#line 367 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                             { (yyval.node) = append_struct_decl_list((yyvsp[0].node), NULL); }
#line 2695 "c11.tab.c"
    break;

  case 138: /* struct_declaration_list: struct_declaration_list struct_declaration  */
#line 368 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                     { (yyval.node) = append_struct_decl_list((yyvsp[0].node), (yyvsp[-1].node)); }
#line 2701 "c11.tab.c"
    break;

  case 139: /* struct_declaration: specifier_qualifier_list ';'  */
#line 372 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                       { make_struct_decl((yyvsp[-1].node), NULL); }
#line 2707 "c11.tab.c"
    break;

  case 140: /* struct_declaration: specifier_qualifier_list struct_declarator_list ';'  */
#line 373 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                              { make_struct_decl((yyvsp[-2].node), (yyvsp[-1].node)); }
#line 2713 "c11.tab.c"
    break;

  case 141: /* struct_declaration: static_assert_declaration  */
#line 374 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { zig_error(); }
#line 2719 "c11.tab.c"
    break;

  case 146: /* struct_declarator_list: struct_declarator  */
#line 385 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                            { (yyval.node) = append_struct_declarator_list((yyvsp[0].node), NULL); }
#line 2725 "c11.tab.c"
    break;

  case 147: /* struct_declarator_list: struct_declarator_list ',' struct_declarator  */
#line 386 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                       { (yyval.node) = append_struct_declarator_list((yyvsp[0].node), (yyvsp[-2].node)); }
#line 2731 "c11.tab.c"
    break;

  case 169: /* declarator: pointer direct_declarator  */
#line 435 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { (yyval.node) = make_idpointer_node((yyvsp[-1].node), (yyvsp[0].node)); }
#line 2737 "c11.tab.c"
    break;

  case 171: /* direct_declarator: IDENTIFIER  */
#line 440 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_identifier_node((yyvsp[0].id)); }
#line 2743 "c11.tab.c"
    break;

  case 172: /* direct_declarator: '(' declarator ')'  */
#line 441 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                             { (yyval.node) = (yyvsp[-1].node); }
#line 2749 "c11.tab.c"
    break;

  case 182: /* direct_declarator: direct_declarator '(' parameter_type_list ')'  */
#line 451 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                        {(yyval.node) = make_name_parameter_node((yyvsp[-3].node), (yyvsp[-1].node)); }
#line 2755 "c11.tab.c"
    break;

  case 183: /* direct_declarator: direct_declarator '(' ')'  */
#line 452 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                    { (yyval.node) = make_name_parameter_node((yyvsp[-2].node), NULL); }
#line 2761 "c11.tab.c"
    break;

  case 187: /* pointer: '*' pointer  */
#line 459 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                      { (yyval.node) = make_pointer_node((yyvsp[0].node)); }
#line 2767 "c11.tab.c"
    break;

  case 188: /* pointer: '*'  */
#line 460 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
              { (yyval.node) = make_pointer_node(NULL); }
#line 2773 "c11.tab.c"
    break;

  case 193: /* parameter_list: parameter_declaration  */
#line 475 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                { (yyval.node) = append_parameter_list((yyvsp[0].node), NULL); }
#line 2779 "c11.tab.c"
    break;

  case 194: /* parameter_list: parameter_list ',' parameter_declaration  */
#line 476 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                   { (yyval.node) = append_parameter_list((yyvsp[0].node), (yyvsp[-2].node)); }
#line 2785 "c11.tab.c"
    break;

  case 195: /* parameter_declaration: declaration_specifiers declarator  */
#line 480 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                            { (yyval.node) = make_assignment_node((yyvsp[0].node), NULL, NULL); }
#line 2791 "c11.tab.c"
    break;

  case 197: /* parameter_declaration: declaration_specifiers  */
#line 482 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                 { (yyval.node) = make_assignment_node((yyvsp[0].node), NULL, NULL); }
#line 2797 "c11.tab.c"
    break;

  case 226: /* initializer: '{' initializer_list '}'  */
#line 526 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                   { (yyval.node) = (yyvsp[-1].node); }
#line 2803 "c11.tab.c"
    break;

  case 227: /* initializer: '{' initializer_list ',' '}'  */
#line 527 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                       { (yyval.node) = (yyvsp[-2].node); }
#line 2809 "c11.tab.c"
    break;

  case 240: /* compound_statement: '{' '}'  */
#line 572 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                  { printf("Empty Block Found\n"); }
#line 2815 "c11.tab.c"
    break;

  case 241: /* compound_statement: '{' block_item_list '}'  */
#line 573 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                   { (yyval.node) = (yyvsp[-1].node); }
#line 2821 "c11.tab.c"
    break;

  case 242: /* block_item_list: block_item  */
#line 577 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { printf("Matched Block_Item\n"); (yyval.node) = append_block_list((yyvsp[0].node), NULL); }
#line 2827 "c11.tab.c"
    break;

  case 243: /* block_item_list: block_item_list block_item  */
#line 578 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                     { printf("Matched Block List then Block Item\n"); (yyval.node) = append_block_list((yyvsp[0].node), (yyvsp[-1].node)); }
#line 2833 "c11.tab.c"
    break;

  case 244: /* block_item: declaration  */
#line 582 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                      { printf("Declaration Found\n"); }
#line 2839 "c11.tab.c"
    break;

  case 245: /* block_item: statement  */
#line 583 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                    { printf("Statement Found\n"); }
#line 2845 "c11.tab.c"
    break;

  case 246: /* expression_statement: ';'  */
#line 587 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
              { (yyval.node) = make_expr_stmt(NULL); }
#line 2851 "c11.tab.c"
    break;

  case 247: /* expression_statement: expression ';'  */
#line 588 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                         { (yyval.node) = make_expr_stmt((yyvsp[-1].node)); }
#line 2857 "c11.tab.c"
    break;

  case 248: /* selection_statement: IF '(' expression ')' statement ELSE statement  */
#line 592 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                         { (yyval.node) = make_if_stmt((yyvsp[-4].node), (yyvsp[-2].node), (yyvsp[0].node)); }
#line 2863 "c11.tab.c"
    break;

  case 249: /* selection_statement: IF '(' expression ')' statement  */
#line 593 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                          { (yyval.node) = make_if_stmt((yyvsp[-2].node), (yyvsp[0].node), NULL); }
#line 2869 "c11.tab.c"
    break;

  case 250: /* selection_statement: IF expression compound_statement ELSE compound_statement  */
#line 594 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                               { (yyval.node) = make_if_stmt((yyvsp[-3].node), (yyvsp[-2].node), (yyvsp[0].node)); }
#line 2875 "c11.tab.c"
    break;

  case 251: /* selection_statement: IF expression compound_statement  */
#line 595 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                       { (yyval.node) = make_if_stmt((yyvsp[-1].node), (yyvsp[0].node), NULL); }
#line 2881 "c11.tab.c"
    break;

  case 254: /* iteration_statement: WHILE '(' expression ')' statement  */
#line 601 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                             { (yyval.node) = make_iteration_stmt((yyvsp[-2].node), (yyvsp[0].node), NULL, NULL); }
#line 2887 "c11.tab.c"
    break;

  case 255: /* iteration_statement: WHILE expression compound_statement  */
#line 602 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                              { (yyval.node) = make_iteration_stmt((yyvsp[-1].node), (yyvsp[0].node), NULL, NULL); }
#line 2893 "c11.tab.c"
    break;

  case 257: /* iteration_statement: FOR expression_statement expression_statement compound_statement  */
#line 604 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                       {(yyval.node) = make_iteration_stmt((yyvsp[-1].node), (yyvsp[0].node), (yyvsp[-2].node), NULL);}
#line 2899 "c11.tab.c"
    break;

  case 258: /* iteration_statement: FOR expression_statement expression_statement expression_statement compound_statement  */
#line 605 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                                            {(yyval.node) = make_iteration_stmt((yyvsp[-2].node), (yyvsp[0].node), (yyvsp[-3].node), (yyvsp[-1].node));}
#line 2905 "c11.tab.c"
    break;

  case 259: /* iteration_statement: FOR declaration expression_statement expression compound_statement  */
#line 606 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                         {(yyval.node) = make_iteration_stmt((yyvsp[-2].node), (yyvsp[0].node), (yyvsp[-3].node), (yyvsp[-1].node));}
#line 2911 "c11.tab.c"
    break;

  case 260: /* iteration_statement: FOR declaration expression_statement compound_statement  */
#line 607 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                              {(yyval.node) = make_iteration_stmt((yyvsp[-1].node), (yyvsp[0].node), (yyvsp[-2].node), NULL);}
#line 2917 "c11.tab.c"
    break;

  case 261: /* iteration_statement: FOR '(' expression_statement expression_statement ')' statement  */
#line 608 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                          { (yyval.node) = make_iteration_stmt((yyvsp[-2].node), (yyvsp[0].node), (yyvsp[-3].node), NULL);}
#line 2923 "c11.tab.c"
    break;

  case 262: /* iteration_statement: FOR '(' expression_statement expression_statement expression ')' statement  */
#line 609 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                                     {(yyval.node) = make_iteration_stmt((yyvsp[-3].node), (yyvsp[0].node), (yyvsp[-4].node), (yyvsp[-2].node));}
#line 2929 "c11.tab.c"
    break;

  case 263: /* iteration_statement: FOR '(' declaration expression_statement ')' statement  */
#line 610 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                 { (yyval.node) = make_iteration_stmt((yyvsp[-2].node), (yyvsp[0].node), (yyvsp[-3].node), NULL);}
#line 2935 "c11.tab.c"
    break;

  case 264: /* iteration_statement: FOR '(' declaration expression_statement expression ')' statement  */
#line 611 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                                            {(yyval.node) = make_iteration_stmt((yyvsp[-3].node), (yyvsp[0].node), (yyvsp[-4].node), (yyvsp[-2].node));}
#line 2941 "c11.tab.c"
    break;

  case 268: /* jump_statement: RETURN ';'  */
#line 618 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                     { (yyval.node) = make_return_node(NULL); }
#line 2947 "c11.tab.c"
    break;

  case 269: /* jump_statement: RETURN expression ';'  */
#line 619 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                { (yyval.node) = make_return_node((yyvsp[-1].node)); }
#line 2953 "c11.tab.c"
    break;

  case 270: /* program: translation_unit  */
#line 623 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                       { root = (yyval.node); }
#line 2959 "c11.tab.c"
    break;

  case 271: /* translation_unit: external_declaration  */
#line 626 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                               { 
        (yyval.node) = append_translation_unit((yyvsp[0].node), NULL);
    }
#line 2967 "c11.tab.c"
    break;

  case 272: /* translation_unit: translation_unit external_declaration  */
#line 629 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                { (yyval.node) = append_translation_unit((yyvsp[0].node), (yyvsp[-1].node)); }
#line 2973 "c11.tab.c"
    break;

  case 276: /* function_definition: declaration_specifiers declarator compound_statement  */
#line 639 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"
                                                               {(yyval.node) = make_function_node((yyvsp[-2].node), (yyvsp[-1].node), (yyvsp[0].node)); }
#line 2979 "c11.tab.c"
    break;


#line 2983 "c11.tab.c"

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

#line 647 "/home/richiewhite/Homework/NyxLang_CS660/gp2/src/c11.y"


/*
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⣳⣻⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⣏⣷⡿⢹⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡻⣡⣷⠟⡀⢼⣷⠧⡶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣯⣽⣿⡓⢄⡐⠠⣀⣶⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⢇⡘⢄⠒⣥⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡴⢯⡇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⡠⣾⣿⣯⣟⡲⣬⣜⣮⣙⡾⢿⣿⣟⡿⣛⠷⣦⣄⡤⢔⣶⣶⣟⡾⣍⢯⣙⣧⢽⣯⡇⠀⠀⠀⠀⠀⠀
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡶⠼⣗⣮⣾⣿⡿⠿⢿⣟⣟⣻⡽⣏⡿⣟⡿⣏⣷⢫⡟⣶⣹⢻⣿⣿⣻⣾⣽⣾⣟⣿⠞⢫⣿⠃⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠇⣀⣼⣿⣿⣁⣀⢀⣼⠿⣼⣳⡽⣯⢿⣹⣷⣻⡼⣣⣟⡲⣭⠳⡽⣿⣯⣷⣿⠟⡻⠁⠚⣿⡏⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠀⣴⣿⣷⡀⠉⢠⣾⣏⡿⣫⢷⣻⣽⣟⡿⣾⢟⣽⣻⣬⢳⣧⢻⡵⣏⣿⣿⣣⢋⢄⣠⢐⣨⡭⠇⠀⠀⠀⠀⠀⠀
⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡵⠟⣿⡿⠹⣿⣶⣿⣷⢞⣽⢯⡿⣷⣿⡽⣿⣻⣿⣷⣟⣾⠿⣜⣣⣞⡧⣿⢿⣷⣩⣾⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣀⣤⣼⣯⣅⣤⣼⣿⣧⣶⢿⣿⣿⣼⣿⣧⣿⣾⣿⣿⣿⣽⣿⣿⣿⣿⣿⣿⣾⣵⣿⣷⣿⣿⣿⣿⣿⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⡟⣯⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡝⠻⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⣃⢘⡀⡛⡘⢃⢃⡘⣀⠛⡘⠛⣃⠘⠛⡇⢿⣿⣿⣿⣿⣿⣧⣿⣿⣿⣿⡿⣿⣿⣿⢏⣧⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣩⣿⣸⠘⡛⡇⠀⠀⠀⠀⠀⠀⠀
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⡔⢠⠂⢡⠐⣁⢂⠰⠀⡌⠄⡡⢀⠜⡐⠰⡘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⡜⣿⣻⣽⣾⣧⢓⢃⠐⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠆⡂⢅⠢⢈⠄⢂⠄⢃⠐⠰⢀⠂⠔⡀⢃⡣⢿⢿⣿⣿⣿⣿⣾⢿⣿⣿⣿⣿⣿⣾⢰⣛⢣⢭⡾⠈⠻⣿⣷⢿⣿⣿⣿⣿⣽⣿⣿⣿⣿⣿⡓⠓⠌⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⡱⠈⡄⠢⢁⠌⠂⡌⠄⢊⠐⠤⢈⡐⠄⢂⠁⠾⣿⣿⣿⣿⣷⣿⣿⡿⣯⣿⣿⣿⣿⣇⠌⠣⠎⠬⠢⣢⠀⠀⣼⣟⣫⠋⣻⣿⣿⣿⣿⡿⢿⣿⣦⠽⡂⠀⠀⠀⠀⠀⠀⠀
⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡗⡠⠑⡠⠑⡈⠄⢃⠰⢈⡐⠌⡐⠄⡐⡈⠤⢈⠴⡙⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣾⢿⣧⡐⢀⠂⠄⢀⠂⠁⣹⡖⡍⣦⣿⣿⣿⣿⣽⢣⢁⡀⠉⡄⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⡅⢊⠤⠑⡈⢌⡐⢂⠂⠔⡐⠠⢊⠐⠠⠌⣀⠢⠘⢌⠻⣿⣿⣿⡿⣿⣿⣿⣿⣿⡿⢆⡈⠉⠣⢌⡐⣀⠌⠰⡉⢁⠙⣻⣿⣿⣿⡿⢃⠇⢤⣴⣡⢀⢃⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡗⠌⡐⠂⠥⡈⠤⠐⢂⢉⠰⢀⠃⢄⠊⡁⢂⠄⠂⠍⠢⠑⠢⠝⡿⡝⣿⣿⣿⣿⡿⢻⣯⣞⢢⠁⠠⠡⡤⡑⠣⡐⢀⣲⣿⣿⣿⡟⠔⠡⡈⠄⣻⡛⢦⡟⢳⡶⠓⡆⠀⣰⠆
⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠎⡐⡉⠰⠐⣂⠉⡄⢊⠐⡈⠔⠂⠤⢁⠂⠌⠌⡐⠡⢈⠤⠁⢅⠰⢼⣿⣽⣾⣙⣧⢞⡽⣷⣾⣄⡐⢠⢐⣡⣴⣿⣿⣿⠏⣛⠿⠿⠐⡠⠑⡨⢉⠍⡋⠉⠁⠀⣇⣠⡓⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢣⠐⡡⢁⠣⢀⠎⡐⠨⠄⡡⢘⠈⠔⢂⠉⡰⠈⠤⠑⣀⠂⣁⢂⣄⣾⠿⡿⠽⠿⠿⣿⣿⠷⢓⠚⡉⠛⠻⣟⢛⣹⣟⠯⠊⡄⠂⡔⠡⠄⢃⠔⡁⠆⡇⠀⠀⠀⠉⠈⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⣂⠱⣀⠃⡌⠢⡐⠌⡁⠆⣁⠢⢉⠰⢈⠰⢀⠱⢈⠡⡀⡲⠚⣹⣿⡯⠟⠋⠍⡐⠠⠀⠄⡐⠂⠡⠀⠄⡁⠈⢯⣢⢀⠂⠥⠐⠡⠄⡑⡈⠆⡰⢈⠔⡁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡗⡠⢡⠐⡌⡐⠡⢄⠃⡌⠰⡀⠆⣁⠒⡈⠔⣈⠰⢈⢢⢊⠔⣫⢻⡽⡱⣈⢂⠡⠐⠀⠀⠀⠀⢈⠐⢀⠀⠠⠁⠈⢷⠢⠜⣨⣭⡭⣗⡔⡁⢢⠁⠆⡌⠄⠀⠀⠀⠀⠀⠀⠀
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠡⢂⠥⡐⠌⡡⢂⠜⠠⡑⢠⠑⡠⠂⠥⠘⡀⠆⣡⢃⢏⣺⢋⡷⢗⡱⠨⡆⡑⢂⠐⢈⠀⢂⠀⠄⠠⠀⠄⡐⠈⠨⡷⣾⣽⡟⣡⡗⣞⡤⢁⠎⡰⣈⠜⣠⠤⠴⢦⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠣⢌⠂⡔⢡⠂⡅⢊⡁⢆⠡⢂⠅⡱⢈⠡⢂⡑⡆⣎⠟⡁⣮⣼⢳⠂⢁⠘⠢⢆⡈⠢⡘⠤⠘⡀⢂⠈⡐⠀⠌⡀⢿⢾⣿⡟⣟⡼⣸⡘⠆⣊⠥⠞⠋⠉⠀⣿⡯⣧⠄⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⡱⢈⠒⢌⡐⢢⠘⢄⠒⡨⢐⠡⢌⠰⢈⠢⢡⢰⢰⡸⢂⢡⢣⣇⡟⠀⠀⠌⠑⠢⢌⡑⢢⡘⠤⢁⠂⡐⠀⠡⢀⡁⢾⡻⢞⣿⣯⡷⡣⣳⠟⠁⠠⢀⠂⠌⡐⠤⢿⣿⡦⠀
⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢅⠊⡌⢢⠘⢄⠊⡄⢣⠐⡡⢊⠰⡈⠆⡑⠢⢼⢸⡇⢢⢸⣽⢲⡀⠄⠀⠀⢈⠐⢠⢉⣾⡴⢃⢎⡐⠠⢁⠂⠄⠠⠸⡿⠭⢒⠭⡍⣱⡟⢀⠡⠂⢤⣜⣤⣣⣯⢗⡾⠃⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⢆⡱⢈⠆⡉⢆⠱⡈⠆⡱⢀⠃⢆⠱⡈⠔⡡⢊⢸⢁⠂⣯⢾⡙⢦⠐⡈⠠⢀⠌⡰⢎⡧⢻⣌⠒⡌⡑⢢⠈⠤⠁⠄⣧⠹⡡⡞⢠⡋⠄⢂⠡⢎⡿⡄⠀⠉⠉⠉⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡗⢢⠐⡡⢊⠔⡈⢆⠱⡈⠔⡡⢊⠔⣂⠱⠘⠤⠡⡼⣼⠘⡧⢾⡝⣪⢣⢔⡡⢎⡜⡱⢎⡜⣣⢯⡘⠤⡑⠠⠑⠂⡁⠂⢸⡆⢷⢡⡟⠀⠌⣂⠱⣺⡰⡇⠀⠀⠀⠀⠀⠀⠀
⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣙⣂⠃⠴⡁⢎⠰⡈⢆⠱⡈⠔⡡⢊⠰⣈⠱⡈⠥⡇⡇⡎⢵⣣⢻⢖⣍⢲⡘⢦⡘⡱⢊⠜⡤⣛⣧⠱⠠⡁⠌⠐⡀⠐⠀⣳⢠⡗⢀⡘⠠⢢⣙⢇⠇⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⢤⢶⡲⣖⠾⣹⢏⣟⡻⣭⢳⢯⣟⣿⡧⡓⢌⠢⡑⢌⠢⡑⢌⠰⣁⠒⡄⢣⠘⡐⠇⢷⣻⡌⢶⢣⠞⣣⡧⡙⠦⡑⠃⡌⢸⢐⢣⢾⣝⣧⠐⡈⠐⡀⠄⠁⠘⡏⢠⠂⠄⡡⢓⡾⢸⠌⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⢶⢫⣏⡳⣬⢏⣶⣳⣞⣻⢷⣻⣞⣷⣯⣿⣻⣾⠟⡡⢋⠄⢣⠘⡄⢣⠘⡄⠣⢄⠣⡘⢄⠣⡘⠼⡸⡵⢧⢊⡯⢞⡡⠞⠃⠆⠡⠂⠌⠄⠊⡜⡧⢿⣞⣆⠄⠡⢐⠠⠈⠄⢻⣃⠌⠰⢡⢯⠇⡇⡌⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⢯⣛⣮⣷⣾⠽⠛⠛⠉⠉⠉⠉⠉⠉⠉⠉⠈⠀⡖⢒⠩⣐⠡⢊⠆⡱⢈⠆⡱⢈⠱⡈⢆⠱⡈⢆⡑⢢⢣⠹⣟⡆⢺⡗⣸⢡⠍⠢⢁⠂⠌⡈⠂⢄⢹⢏⣿⡼⣆⢁⠂⡐⠈⡄⢃⣯⠰⣡⢋⡞⢸⠰⡐⡇⠀⠀⠀⠀⠀⠀⠀
⠁⠀⠀⠀⠀⠀⠀⣰⢯⡷⣯⣿⡿⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣏⠢⡑⡄⠣⢌⠢⡑⢌⠢⡑⢌⠢⡑⢌⠢⡑⢢⠘⡄⠦⠱⡙⣽⡄⢿⡥⠳⣌⠱⡀⠌⡐⠠⢉⠀⡂⢯⣚⢿⡼⣆⠱⡀⢡⠘⡠⢺⡱⣌⡿⢡⢃⠣⡐⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣼⢯⣿⣽⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠣⡔⢡⠃⡌⢒⢡⠊⡔⢡⠊⡔⢡⠊⡔⢡⠢⡑⣘⠢⣑⠺⢸⢜⡈⢳⡝⢦⡑⠬⡐⠄⢃⠄⠒⡈⠄⣏⡞⣽⣭⢧⠰⡁⢎⡐⢣⠓⣼⢃⠎⣌⠱⡀⠇⠀⠀⠀⠀⠀⠀⠀
⡀⠀⠀⠀⠀⣼⣯⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠱⡈⢆⠱⡈⢆⢡⠊⡔⢡⠊⡔⢡⠊⡔⠡⢆⠱⣀⠣⢄⠃⢸⢚⢄⠈⢿⡢⡝⢢⠑⡌⢢⠈⢂⠑⡈⠜⣮⢵⣻⣎⠳⡌⢆⡍⢦⢹⠃⡬⠘⡄⢣⠘⡄⠀⠀⠀⠀⠀⠀⠀
⠄⠀⠀⠀⢸⣿⣽⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠣⡘⢄⡣⠜⣀⣂⣥⣬⣤⣅⣚⡠⠧⣌⠱⣈⠒⡄⠣⢌⢲⢸⢚⡈⠄⢸⡷⣉⠆⡱⠈⠄⠈⠀⠄⠐⡈⠜⡖⡧⡿⣧⣙⠶⣘⣦⢃⠜⣐⠣⡘⢄⠣⠄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣿⣿⢿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠖⣫⡵⣞⢻⣝⣫⣞⣵⡺⣜⣯⣻⡽⣶⢮⣒⠭⣐⡉⡦⢝⡾⠆⢇⠂⣼⠳⢡⠘⢠⠁⠂⡁⠠⠀⠐⠠⢌⠹⡖⡟⢘⠻⠮⠵⢃⠎⡜⢠⠃⡜⡠⢃⠆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡻⣧⢷⣯⣿⣾⠿⠽⠾⠿⠿⣷⣿⣽⣾⣯⣿⣷⣌⡥⠚⢅⢊⠜⠤⢢⡿⣁⠃⢌⠀⠆⠡⠐⠀⠂⠁⠎⡄⢃⢜⡇⢸⠊⡍⢍⠣⡑⢌⠢⡑⠬⡐⢡⠂⠀⠀⠀⠀⠀⠀⠀
⡃⠀⠀⠀⢿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⡿⣻⣍⢦⣟⢦⡜⡇⢿⡝⡻⣿⣿⣿⣿⣿⣷⡄⢨⡘⡼⣦⡿⣧⢏⠸⣨⡜⢆⠃⠆⠀⢀⠃⠆⡝⢮⢸⠁⡏⣞⢱⡘⣆⢳⡘⣆⡳⢦⠳⢮⠃⠀⠀⠀⠀⠀⠀⠀
⠁⠀⠀⠀⠘⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⡿⢻⠱⢳⠹⡜⢧⡜⢦⠳⡝⣮⢿⡵⢻⠛⣿⣿⣿⣿⣿⣶⡷⣾⠏⡟⢦⠋⡞⢱⠸⠈⠞⠀⡄⠈⡜⠶⡝⡏⡾⢸⠹⡌⢧⠹⡌⢧⠹⣬⠹⣬⠛⡎⠃⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠙⣿⣿⣽⣿⣿⣦⣤⣀⡀⠀⠀⠀⠀⣀⣠⣴⣾⣿⣿⣿⣿⠿⠫⠄⠥⢃⠆⡱⢈⠆⡘⡤⢗⣩⠖⠋⢀⠂⡱⢈⠿⣿⣿⣿⣿⠿⢋⠔⡈⢎⠱⣈⠆⢡⠉⡐⢀⠀⠆⡐⢢⢳⠁⡇⡎⠱⠌⠦⠑⠈⠂⠓⠂⣁⣀⠁⡈⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣾⣿⣽⣻⣽⢿⣿⣿⣿⢿⣟⣿⣿⣿⣿⠟⠁⠀⡧⢉⠆⡥⢊⠔⣡⠞⣪⠔⠋⠀⠀⢀⠂⠰⣀⢃⢎⡹⣿⠻⠏⡜⠠⢊⡴⢊⠱⡀⠎⠐⠠⠐⠠⠈⡔⢡⠣⣍⢰⡇⡖⣄⣢⣄⣩⢉⡔⠢⠑⠂⠆⠣⠘⠄⠀⠀⠀⠀⠀⠀⠀
⡁⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⣿⣿⣿⣿⣷⣿⣿⣿⣿⠿⠟⠉⠀⠀⠀⠀⣇⠣⡘⠤⢃⡜⢡⡾⠃⠀⠀⠀⠀⡀⠈⢡⠀⢎⠦⣑⢩⡥⢗⡚⠱⡉⠔⡁⠂⠔⠈⠠⠁⡐⠠⢑⡈⢆⡱⢼⣸⢠⣀⠄⡠⣐⠐⡒⢒⠒⡒⢒⠒⣂⠒⡄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠣⣘⢐⠏⣰⠃⠀⠀⠀⡀⠀⠀⠠⢁⠂⡘⢌⣶⡷⢋⠜⢂⠈⠁⠐⡀⠀⢁⠂⠈⡐⠠⢄⡑⢢⠘⡤⢣⢷⠇⡎⡔⢨⠔⠤⠓⡌⢢⠑⡌⢂⠳⢠⠃⡆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⡱⢀⡏⢰⢃⠆⠠⢈⠐⡀⠠⠈⠐⡀⢂⢱⣾⠋⡔⠡⢈⠠⠀⠀⠀⠀⠐⠀⠠⠁⠄⡡⢂⠜⣠⢋⠴⣋⣾⡀⡇⡜⢠⠊⡔⢣⠘⡄⢣⠘⠤⡉⢆⠱⡀⠀⠀⠀⠀⠀⠀⠀
⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣁⠩⠄⠀⡏⡼⡈⢅⠂⡐⠠⠀⡀⠂⠐⣨⡾⢡⠃⡌⠐⡀⠀⠀⡀⠄⠠⠁⠂⢁⠈⡐⢐⠠⠒⠠⡍⢎⡵⣊⣇⢱⡘⢄⠣⡘⢄⠣⡘⠤⡉⢆⠱⡈⢆⡁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⣒⢺⠀⡇⡷⡁⢎⡐⠠⢀⠁⡀⠠⠁⣼⡥⢃⠜⣀⠡⠀⡌⠐⡄⠌⡄⠃⠌⡀⢂⠰⢈⠆⡁⢣⠜⣌⢲⡱⢺⠈⡜⡄⢣⠘⡄⢣⠘⠤⡑⠌⣆⠑⡢⠄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡗⡄⢺⠀⡇⡷⡉⢆⡘⠄⢂⠐⠠⠐⠠⣿⠰⣁⠢⢀⠜⡐⠄⡃⠔⠡⡘⠨⡐⠠⢁⠒⡨⢠⠑⠢⢍⢆⢣⡝⡭⡇⢳⢈⠆⡱⢈⠆⡉⢆⠱⡈⠤⢃⡑⡂⠀⠀⠀⠀⠀⠀⠀
⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡗⡌⡡⠇⢹⡸⡑⣎⠰⣁⠂⠌⠠⠉⢄⢻⡔⡡⢒⢈⡐⠌⡰⠈⠌⡡⠐⠡⠐⡁⠂⠌⡐⠠⢉⠒⠌⡌⢆⢳⢂⢷⠸⢌⠢⡑⢌⠢⡑⢌⢢⣁⢃⡒⠤⡁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠓⠒⠑⠚⠈⢷⡽⡤⢓⡄⢣⠘⠤⣉⠢⣹⣖⡱⢌⠢⢌⠰⠠⢑⠨⢐⠡⣁⠒⡠⢉⠔⣀⠃⡰⢈⠒⡌⣘⠢⢭⢸⠀⠃⠂⠑⠈⠂⠑⠈⠂⠐⠂⠘⠀⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣝⡧⡘⢦⣉⠲⣄⠳⣐⢻⣜⢎⡕⣊⠦⡑⡈⢆⠡⠒⠤⠑⡠⢂⠒⠠⢃⡐⡀⠎⠰⣈⠞⠬⡘⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⡙⢆⢆⡓⢌⠲⢡⢎⠻⢾⣴⢡⡒⢥⢊⡄⢣⠉⡔⠡⠒⡈⠌⡁⢂⠠⠐⠈⠂⠔⣊⠱⡂⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣯⠜⡢⠜⣌⢃⠣⣌⢣⡙⠷⣗⠍⣆⠣⢜⠢⡑⢌⠢⡑⡐⠄⡡⢀⠀⠄⠈⠄⡡⢂⠱⡁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡈⢿⣦⡙⡰⢊⡱⢄⠲⣈⠕⡸⢮⣄⢋⠆⣣⠙⡌⠦⡑⠰⡈⠔⡀⠂⠌⠐⡠⠑⡌⢆⡁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
*/

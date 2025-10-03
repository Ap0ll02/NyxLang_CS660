/* based on n3220.pdf */
%code requires {
#include "cst.h"
}
%locations
%define api.pure full
%parse-param { void * yyscanner }
%parse-param { ParseUnit *parse_ptr }
%lex-param { void * yyscanner }
%define api.value.type {CSTnodeptr}
/*%define parse.error verbose*/
%define parse.error custom

%expect 37
/* %token ENDOFFILE 0 */
%token	IDENTIFIER I_CONSTANT F_CONSTANT STRING_LITERAL FUNC_NAME SIZEOF
%token	PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token	AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token	SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token	XOR_ASSIGN OR_ASSIGN
%token	TYPEDEF_NAME ENUMERATION_CONSTANT

%token	TYPEDEF EXTERN STATIC AUTO REGISTER INLINE
%token	CONST RESTRICT VOLATILE
%token	BOOL CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE VOID
%token	COMPLEX IMAGINARY BITINT DECIMAL32 DECIMAL64 DECIMAL128
%token	STRUCT UNION ENUM ELLIPSIS

%token	CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token	CONSTEXPR ALIGNAS ALIGNOF ATOMIC GENERIC NORETURN STATIC_ASSERT THREAD_LOCAL
%token  TYPEOF_UNQUAL TYPEOF
%token PREPROCESSING_TOKEN TRUE FALSE NULLPTR
%token ATTRIBUTE_HACK
%start start_rule

%code {
#include <stdio.h>
#include "cst.h"
int yylex (YYSTYPE * yyval_param, YYLTYPE * yylloc_param, void * yyscanner);
}

%code provides {
extern void yyerror(YYLTYPE *yylloc, void * yyscanner, ParseUnit *parse_ptr, const char *s);
}

%%
start_rule
        : translation_unit
        ;
//START_LEXICAL_GRAMMAR
// /* 6.4 Lexical elements */
// token:
//  keyword
// | IDENTIFIER
// | constant
// | string_literal
// | punctuator
// ;
// preprocessing_token:
//  header_name
// | IDENTIFIER
// | pp_number
// | character_constant
// | string_literal
// | punctuator
// /* | each universal_character_name that cannot be one of the above */
// /* | each non_white_space character that cannot be one of the above */
// ;
// 
// /* 6.4.1 Keywords */
// keyword: "alignas" | "alignof" | "auto" | "bool" | "break" | "case" | "char" | "const" | "constexpr" | "continue" | "default"
// | "do" | "double" | "else" | "enum" | "extern" | "false" | "float" | "for" | "goto" | "if" | "inline"
// | "int" | "long" | "nullptr" | "register" | "restrict" | "return" | "short" | "signed" | "sizeof" | "static" | "static_assert"
// | "struct" | "switch" | "thread_local" | "true" | "typedef" | "typeof" | "typeof_unqual" | "union" | "unsigned" | "void"
// | "volatile"
// | "while" | "_Atomic" | "_BitInt" | "_Complex" | "_Decimal128" | "_Decimal32" | "_Decimal64" | "_Generic" | "_Imaginary"
// | "_Noreturn" | keyword_alternate_spelling
// ;
// keyword_alternate_spelling: "_Alignas" | "_Alignof" | "_Bool" | "_Static_assert" | "_Thread_local"
// ;
// 
// /* 6.4.2 Identifiers */
// /* 6.4.2.1 General */
// identifier:
//  identifier_start
// | identifier identifier_continue
// ;
// identifier_start:
//  nondigit
// /* | XID_Start_character */
// | universal_character_name_of_class_XID_Start
// ;
// identifier_continue:
//  digit
// | nondigit
// /* | XID_Continue_character */
// | universal_character_name_of_class_XID_Continue
// ;
// /*
// XID_Start_character:
//  "unspecified"
// ;
// XID_Continue_character:
//  "unspecified"
// ;
// */
// nondigit: '_' | '$'
//       | 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm'
//       | 'n' | 'o' | 'p' | 'q' | 'r' | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z'
//       | 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M'
//       | 'N' | 'O' | 'P' | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z'
// ;
// digit: '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
// ;
// /* 6.4.2.2 Predefined identifiers */
// /* The identifier __func__ shall be implicitly declared by the translator as if, immediately following
// the opening brace of each function definition, the declaration
// 
//     static const char __func__ [] = "function-name";
// 
// appeared, where function-name is the name of the lexically-enclosing function. */
// 
// /* 6.4.3 Universal character names */
// universal_character_name_of_class_XID_Start: universal_character_name
// ;
// universal_character_name_of_class_XID_Continue: universal_character_name
// ;
// universal_character_name: /* not in D800-DFFF inclusive; not greater than 10FFFF */
// | "\\u" hex_quad
// | "\\U" hex_quad hex_quad
// ;
// hex_quad:
//  hexadecimal_digit hexadecimal_digit hexadecimal_digit hexadecimal_digit
// ;
// /* 6.4.4 Constants */
// /* 6.4.4.1 General */
// constant:
//  integer_constant
// | floating_constant
// | enumeration_constant
// | character_constant
// | predefined_constant
// ;
// /* 6.4.4.2 Integer constants */
// integer_constant:
//  decimal_constant integer_suffix_opt
// | octal_constant integer_suffix_opt
// | hexadecimal_constant integer_suffix_opt
// | binary_constant integer_suffix_opt
// ;
// decimal_constant:
//  nonzero_digit
// | decimal_constant digit_separator_opt digit
// ;
// digit_separator_opt:
// | '\''
// ;
// octal_constant:
//  '0'
// | octal_constant digit_separator_opt octal_digit
// ;
// hexadecimal_constant:
//  hexadecimal_prefix hexadecimal_digit_sequence
// ;
// binary_constant:
//  binary_prefix binary_digit
// | binary_constant digit_separator_opt binary_digit
// ;
// hexadecimal_prefix: "0x" | "0X"
// ;
// binary_prefix: "0b" | "0B"
// ;
// nonzero_digit:
// '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
// ;
// octal_digit:
// '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7'
// ;
// hexadecimal_digit_sequence_opt:
// | hexadecimal_digit_sequence
// ;
// hexadecimal_digit_sequence:
//  hexadecimal_digit
// | hexadecimal_digit_sequence digit_separator_opt hexadecimal_digit
// ;
// hexadecimal_digit:
// '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
// | 'a' | 'b' | 'c' | 'd' | 'e' | 'f'
// | 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
// ;
// binary_digit: '0' | '1'
// ;
// integer_suffix_opt:
//  unsigned_suffix long_suffix_opt
// | unsigned_suffix long_long_suffix
// | unsigned_suffix bit_precise_int_suffix
// | long_suffix unsigned_suffix_opt
// | long_long_suffix unsigned_suffix_opt
// | bit_precise_int_suffix unsigned_suffix_opt
// ;
// bit_precise_int_suffix: "wb" | "WB"
// ;
// unsigned_suffix_opt:
// | unsigned_suffix
// ;
// unsigned_suffix: 'u' | 'U'
// ;
// long_suffix_opt:
// | long_suffix
// ;
// long_suffix: 'l' | 'L'
// ;
// long_long_suffix: "ll" | "LL"
// ;
// /* 6.4.4.3 Floating constants */
// floating_constant:
//  decimal_floating_constant
// | hexadecimal_floating_constant
// ;
// decimal_floating_constant:
//  fractional_constant exponent_part_opt floating_suffix_opt
// | digit_sequence exponent_part floating_suffix_opt
// ;
// hexadecimal_floating_constant:
//  hexadecimal_prefix hexadecimal_fractional_constant binary_exponent_part nondecimal_floating_suffix_opt
// | hexadecimal_prefix hexadecimal_digit_sequence binary_exponent_part nondecimal_floating_suffix_opt
// ;
// fractional_constant:
//  digit_sequence_opt '.' digit_sequence
// | digit_sequence '.'
// ;
// exponent_part_opt:
// | exponent_part
// ;
// exponent_part:
//  'e' sign_opt digit_sequence
// | 'E' sign_opt digit_sequence
// ;
// sign_opt:
// | sign
// ;
// sign: '+' | '-'
// ;
// digit_sequence_opt:
// | digit_sequence
// ;
// digit_sequence:
//  digit
// | digit_sequence digit_separator_opt digit
// ;
// hexadecimal_fractional_constant:
//  hexadecimal_digit_sequence_opt '.' hexadecimal_digit_sequence
// | hexadecimal_digit_sequence '.'
// ;
// binary_exponent_part:
//  'p' sign_opt digit_sequence
// | 'P' sign_opt digit_sequence
//  /* Nota Bene! exponents for hex floats are powers of 2,
//     but are nevertheless expressed in decimal! */
// ;
// floating_suffix_opt:
// | nondecimal_floating_suffix
// | decimal_floating_suffix
//  /* Nota Bene! the constraint that decimal suffixes shall not be
//     used with hex floats is expressed through a few extra rules */
// ;
// nondecimal_floating_suffix_opt:
// | nondecimal_floating_suffix
// ;
// nondecimal_floating_suffix: 'f' | 'l' | 'F' | 'L'
// ;
// decimal_floating_suffix: "df" | "dd" | "dl" | "DF" | "DD" | "DL"
// ;
// /* 6.4.4.4 Enumeration constants */
// enumeration_constant:
//  identifier
// ;
// /* 6.4.4.5 Character constants */
// character_constant:
//  encoding_prefix_opt '\'' c_char_sequence '\''
// ;
// encoding_prefix_opt:
// | "u8" | 'u' | 'U' | 'L'
// ;
// c_char_sequence:
//  c_char
// | c_char_sequence c_char
// ;
// c_char:
//  /* any member of the source character set except the single_quote ', backslash \, or new_line character */
// | escape_sequence
// ;
// escape_sequence:
//  simple_escape_sequence
// | octal_escape_sequence
// | hexadecimal_escape_sequence
// | universal_character_name
// ;
// simple_escape_sequence: "\\\'" | "\\\"" | "\\?" | "\\\\"
// | "\\a" | "\\b" | "\\f" | "\\n" | "\\r" | "\\t" | "\\v"
// ;
// octal_escape_sequence:
//  '\\' octal_digit
// | '\\' octal_digit octal_digit
// | '\\' octal_digit octal_digit octal_digit
// ;
// hexadecimal_escape_sequence:
//  "\\x" hexadecimal_digit
// | hexadecimal_escape_sequence hexadecimal_digit
// ;
// /* 6.4.4.6 Predefined constants */
// predefined_constant:
//  "false"
// | "true"
// | "nullptr"
// ;
// /* 6.4.5 String literals */
// string_literal:
// | encoding_prefix_opt '"' s_char_sequence_opt '"'
// ;
// s_char_sequence_opt:
// | s_char_sequence
// ;
// s_char_sequence:
//  s_char
// | s_char_sequence s_char
// ;
// s_char:
//  /*any member of the source character set except the double_quote ", backslash \, or new_line character*/
// | escape_sequence
// ;
// /* 6.4.6 Punctuators */
// punctuator:
// '[' | ']' | '(' | ')' | '{' | '}' | '.' | "->"
// | "++" | "--" | '&' | '*' | '+' | '-' | '~' | '!'
// | '/' | '%' | "<<" | ">>" | '<' | '>' | "<=" | ">=" | "==" | "!=" | '^' | '|' | "&&" | "||"
// | '?' | ':' | "::" | ';' | "..."
// | '=' | "*=" | "/=" | "%=" | "+=" | "-=" | "<<=" | ">>=" | "&=" | "^=" | "|="
// | ',' | '#' | "##"
// | "<:" | ":>" | "<%" | "%>" | "%:" | "%:%:"
// ;
// /* 6.4.7 Header names */
// header_name:
//  '<' h_char_sequence '>'
// | '"' q_char_sequence '"'
// ;
// h_char_sequence:
//  h_char
// | h_char_sequence h_char
// ;
// h_char:
//  /*any member of the source character set except the new_line character and > */
// ;
// q_char_sequence:
//  q_char
// | q_char_sequence q_char
// ;
// q_char:
// /*any member of the source character set except the new_line character and " */
// ;
// /* 6.4.8 Preprocessing numbers */
// pp_number:
//  digit
// | '.' digit
// | pp_number identifier_continue
// | pp_number '\'' digit
// | pp_number '\'' nondigit
// | pp_number 'e' sign
// | pp_number 'E' sign
// | pp_number 'p' sign
// | pp_number 'P' sign
// | pp_number '.'
// ;
// /* 6.4.9 Comments */
// /* Nota Bene! Section 6.4.9 does not specify grammar rules for comments. Rules
//    are provided here based on the description in 6.4.9 */
// comment: inline_comment | endline_comment
// ;
// inline_comment: "/*" inline_comment_chars "*/"
// ;
// inline_comment_chars:
// | inline_comment_chars inline_comment_char
// | inline_comment_chars '*' inline_comment_char
// | inline_comment_chars '/' 
// ;
// inline_comment_char: /* any valid source character except '/' and '*' */
// ;
// endline_comment: "//" endline_comment_chars new_line
// ;
// endline_comment_chars:
// | endline_comment_chars endline_comment_char
// ;
// endline_comment_char: /* any valid source character except newline */
// ;
//END_LEXICAL_GRAMMAR
//START_MAIN_GRAMMAR
// hoisted definitions from above:
enumeration_constant
        : IDENTIFIER
        ;

identifier
        : IDENTIFIER
        ;

string_literal
        : STRING_LITERAL
        ;

constant
        : I_CONSTANT
        | F_CONSTANT
        | ENUMERATION_CONSTANT
        | TRUE
        | FALSE
        | NULLPTR
        ;


/* main grammar */
/* 6.5 Expressions */

/* 6.5.1 General */

/* 6.5.2 Primary expressions */

primary_expression
        : IDENTIFIER
        | constant
        | string_literal
        | '(' expression ')'
        | generic_selection
        ;

/* 6.5.2.1 Generic selection */

generic_selection
        : GENERIC '(' assignment_expression ',' generic_assoc_list ')'
        ;

generic_assoc_list
        : generic_association
        | generic_assoc_list ',' generic_association
        ;

generic_association
        : type_name ':' assignment_expression
        | DEFAULT ':' assignment_expression
        ;
/* 6.5.3 Postfix operators */
/* 6.5.3.1 General */

postfix_expression
        : primary_expression
/* NONC_RULE | postfix_expression '[' ']' TBA */
        | postfix_expression '[' expression ']'
        | postfix_expression '(' ')'
        | postfix_expression '(' argument_expression_list ')'
        | postfix_expression '.' identifier
        | postfix_expression PTR_OP identifier
        | postfix_expression INC_OP
        | postfix_expression DEC_OP
        | compound_literal
        ;

argument_expression_list
        : assignment_expression
        | argument_expression_list ',' assignment_expression
        ;

/* 6.5.3.2 Array subscripting */
/* this section defines no syntax */

/* 6.5.3.3 Function calls */
/* this section defines no syntax */

/* 6.5.3.6 Compound literals */

compound_literal
        : '(' type_name ')' braced_initializer
        | '(' storage_class_specifiers type_name ')' braced_initializer
        ;

storage_class_specifiers
        : storage_class_specifier
        | storage_class_specifiers storage_class_specifier
        ;

/* 6.5.4 Unary operators */

unary_expression
        : postfix_expression
        | INC_OP unary_expression
        | DEC_OP unary_expression
        | unary_operator cast_expression
        | SIZEOF unary_expression
        | SIZEOF '(' type_name ')'
        | ALIGNOF '(' type_name ')'
        ;

unary_operator
        : '&'
        | '*'
        | '+'
        | '-'
        | '~'
        | '!'
        ;

/* 6.5.5 Cast operators */

cast_expression
        : unary_expression
        | '(' type_name ')' cast_expression
        ;

/* 6.5.6 Multiplicative operators */

multiplicative_expression
        : cast_expression
        | multiplicative_expression '*' cast_expression
        | multiplicative_expression '/' cast_expression
        | multiplicative_expression '%' cast_expression
        ;

/* 6.5.7 Additive operators */
additive_expression
        : multiplicative_expression
        | additive_expression '+' multiplicative_expression
        | additive_expression '-' multiplicative_expression
        ;

/* 6.5.8 Bitwise shift operators */

shift_expression
        : additive_expression
        | shift_expression LEFT_OP additive_expression
        | shift_expression RIGHT_OP additive_expression
        ;

/* 6.5.9 Relational operators */

relational_expression
        : shift_expression
        | relational_expression '<' shift_expression
        | relational_expression '>' shift_expression
        | relational_expression LE_OP shift_expression
        | relational_expression GE_OP shift_expression
        ;

/* 6.5.10 Equality operators */

equality_expression
        : relational_expression
        | equality_expression EQ_OP relational_expression
        | equality_expression NE_OP relational_expression
        ;

/* 6.5.11 Bitwise AND operator */

and_expression
        : equality_expression
        | and_expression '&' equality_expression
        ;

/* 6.5.12 Bitwise exclusive OR operator */

exclusive_or_expression
        : and_expression
        | exclusive_or_expression '^' and_expression
        ;

/* 6.5.13 Bitwise inclusive OR operator */

inclusive_or_expression
        : exclusive_or_expression
        | inclusive_or_expression '|' exclusive_or_expression
        ;

/* 6.5.14 Logical AND operator */

logical_and_expression
        : inclusive_or_expression
        | logical_and_expression AND_OP inclusive_or_expression
        ;

/* 6.5.15 Logical OR operator */

logical_or_expression
        : logical_and_expression
        | logical_or_expression OR_OP logical_and_expression
        ;

/* 6.5.16 Conditional operator */

conditional_expression
        : logical_or_expression
        | logical_or_expression '?' expression ':' conditional_expression
        ;

/* 6.5.17 assignment operators */

assignment_expression
        : conditional_expression
        | unary_expression assignment_operator assignment_expression
        ;

assignment_operator
        : '='
        | MUL_ASSIGN
        | DIV_ASSIGN
        | MOD_ASSIGN
        | ADD_ASSIGN
        | SUB_ASSIGN
        | LEFT_ASSIGN
        | RIGHT_ASSIGN
        | AND_ASSIGN
        | XOR_ASSIGN
        | OR_ASSIGN
        ;

/* 6.5.17.3 Compound assignment */
/* this section defines no syntax */

/* 6.5.18 Comma operator */

expression
        : assignment_expression
        | expression ',' assignment_expression
        ;

/* 6.6 Constant expressions */
/* this section defines syntax, but constraints are not expressed syntactically */

constant_expression
        : conditional_expression
        ;

/* 6.7 Declarations */
/* 6.7.1 General */

declaration
        : declaration_specifiers ';'
        | declaration_specifiers init_declarator_list ';'
        | attribute_specifier_sequence declaration_specifiers init_declarator_list ';'
        | static_assert_declaration
        | attribute_declaration
        ;

declaration_specifiers
        : declaration_specifier
        | declaration_specifier attribute_specifier_sequence
        | declaration_specifier declaration_specifiers
        ;

declaration_specifier
        : storage_class_specifier
        | type_specifier_qualifier
        | function_specifier
        ;

init_declarator_list
        : init_declarator
        | init_declarator_list ',' init_declarator
        ;

init_declarator
        : declarator '=' initializer
        | declarator
        ;

attribute_declaration
        : attribute_specifier_sequence ';'
        ;

/* 6.7.2 Storage-class specifiers */

storage_class_specifier
        : AUTO
        | CONSTEXPR
        | EXTERN
        | REGISTER
        | STATIC
        | THREAD_LOCAL
        | TYPEDEF
        ;

/* 6.7.3 Type specifiers */
/* 6.7.3.1 General */

type_specifier
        : VOID
        | CHAR
        | SHORT
        | INT
        | LONG
        | FLOAT
        | DOUBLE
        | SIGNED
        | UNSIGNED
        | BITINT '(' constant_expression ')'
        | BOOL
        | COMPLEX
        | IMAGINARY
        | DECIMAL32
        | DECIMAL64
        | DECIMAL128
        | atomic_type_specifier
        | struct_or_union_specifier
        | enum_specifier
        | TYPEDEF_NAME
        | typeof_specifier
        ;

/* 6.7.3.2 Structure and union specifiers */

struct_or_union_specifier
        : struct_or_union '{' member_declaration_list '}'
        | struct_or_union identifier '{' member_declaration_list '}'
        | struct_or_union identifier
        | struct_or_union attribute_specifier_sequence '{' member_declaration_list '}'
        | struct_or_union attribute_specifier_sequence identifier '{' member_declaration_list '}'
        | struct_or_union attribute_specifier_sequence identifier
        ;

struct_or_union
        : STRUCT
        | UNION
        ;

member_declaration_list
        : member_declaration
        | member_declaration_list member_declaration
        ;

member_declaration
        : specifier_qualifier_list ';'
        | specifier_qualifier_list member_declarator_list ';'
        | attribute_specifier_sequence specifier_qualifier_list ';'
        | attribute_specifier_sequence specifier_qualifier_list member_declarator_list ';'
        | static_assert_declaration
        ;

specifier_qualifier_list
        : type_specifier_qualifier
        | type_specifier_qualifier attribute_specifier_sequence
        | type_specifier_qualifier specifier_qualifier_list
        ;

type_specifier_qualifier
        : type_specifier
        | type_qualifier
        | alignment_specifier
        ;

member_declarator_list
        : member_declarator
        | member_declarator_list ',' member_declarator
        ;

member_declarator
        : ':' constant_expression
        | declarator ':' constant_expression
        | declarator
        ;

/* 6.7.3.3 Enumeration specifiers */
enum_specifier
        : ENUM '{' enumerator_list '}'
        | ENUM '{' enumerator_list ',' '}'
        | ENUM identifier '{' enumerator_list '}'
        | ENUM identifier '{' enumerator_list ',' '}'
        | ENUM identifier 
        | ENUM enum_type_specifier '{' enumerator_list '}'
        | ENUM enum_type_specifier '{' enumerator_list ',' '}'
        | ENUM identifier enum_type_specifier '{' enumerator_list '}'
        | ENUM identifier enum_type_specifier '{' enumerator_list ',' '}'
        | ENUM identifier enum_type_specifier
        | ENUM attribute_specifier_sequence '{' enumerator_list '}'
        | ENUM attribute_specifier_sequence '{' enumerator_list ',' '}'
        | ENUM attribute_specifier_sequence identifier '{' enumerator_list '}'
        | ENUM attribute_specifier_sequence identifier '{' enumerator_list ',' '}'
        | ENUM attribute_specifier_sequence enum_type_specifier '{' enumerator_list '}'
        | ENUM attribute_specifier_sequence enum_type_specifier '{' enumerator_list ',' '}'
        | ENUM attribute_specifier_sequence identifier enum_type_specifier '{' enumerator_list '}'
        | ENUM attribute_specifier_sequence identifier enum_type_specifier '{' enumerator_list ',' '}'
        | ENUM attribute_specifier_sequence identifier enum_type_specifier
        ;

enumerator_list
        : enumerator
        | enumerator_list ',' enumerator
        ;

enumerator
        : enumeration_constant '=' constant_expression
        | enumeration_constant
        | enumeration_constant attribute_specifier_sequence '=' constant_expression
        | enumeration_constant attribute_specifier_sequence
        ;

enum_type_specifier
        : ':' specifier_qualifier_list
        ;

/* 6.7.3.4 Tags */
 
/* this section defines no syntax */

/* 6.7.3.5 Atomic type specifiers */

atomic_type_specifier
        : ATOMIC '(' type_name ')'
        ;

/* 6.7.3.6 Typeof specifiers */

typeof_specifier
        : TYPEOF '(' typeof_specifier_argument ')'
        | TYPEOF_UNQUAL '(' typeof_specifier_argument ')'
        ;

typeof_specifier_argument
        : expression
        | type_name
        ;

/* 6.7.4 Type qualifiers */
type_qualifier
        : CONST
        | RESTRICT
        | VOLATILE
        | ATOMIC
        ;

/* 6.7.5 Function specifiers */

function_specifier
        : INLINE
        | NORETURN
        ;

/* 6.7.6 Alignment specifier */

alignment_specifier
        : ALIGNAS '(' type_name ')'
        | ALIGNAS '(' constant_expression ')'
        ;

/* 6.7.7 Declarators */
/* 6.7.7.1 General */

declarator
        : pointer direct_declarator
        | direct_declarator
        ;

direct_declarator
        : identifier
        | '(' declarator ')'
        | array_declarator
        | function_declarator
        | identifier attribute_specifier_sequence
        | array_declarator attribute_specifier_sequence
        | function_declarator attribute_specifier_sequence
        ;

array_declarator
        : direct_declarator '[' ']'
        | direct_declarator '[' '*' ']'
        | direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
        | direct_declarator '[' STATIC assignment_expression ']'
        | direct_declarator '[' type_qualifier_list '*' ']'
        | direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
        | direct_declarator '[' type_qualifier_list assignment_expression ']'
        | direct_declarator '[' type_qualifier_list ']'
        | direct_declarator '[' assignment_expression ']'
        ;

function_declarator
        : direct_declarator '(' parameter_type_list ')'
        | direct_declarator '(' ')'
        ;

pointer
        : '*' type_qualifier_list pointer
        | '*' type_qualifier_list
        | '*' pointer
        | '*' 
        | '*' attribute_specifier_sequence type_qualifier_list pointer
        | '*' attribute_specifier_sequence type_qualifier_list
        | '*' attribute_specifier_sequence pointer
        | '*' attribute_specifier_sequence  
        ;

type_qualifier_list
        : type_qualifier
        | type_qualifier_list type_qualifier
        ;

parameter_type_list
        : parameter_list ',' ELLIPSIS
        | parameter_list
        | ELLIPSIS
        ;

parameter_list
        : parameter_declaration
        | parameter_list ',' parameter_declaration
        ;

parameter_declaration
        : declaration_specifiers declarator
        | declaration_specifiers abstract_declarator
        | declaration_specifiers
        | attribute_specifier_sequence declaration_specifiers declarator
        | attribute_specifier_sequence declaration_specifiers abstract_declarator
        | attribute_specifier_sequence declaration_specifiers
        ;

/* 6.7.7.2 Pointer declarators */
/* this section defines no syntax */
/* 6.7.7.3 Array declarators */
/* this section defines no syntax */
/* 6.7.7.4 Function declarators */
/* this section defines no syntax */

/* 6.7.8 Type names */

type_name
        : specifier_qualifier_list abstract_declarator
        | specifier_qualifier_list
        ;

abstract_declarator
        : pointer direct_abstract_declarator
        | pointer
        | direct_abstract_declarator
        ;

direct_abstract_declarator
        : '(' abstract_declarator ')'
        | array_abstract_declarator
        | function_abstract_declarator
        | array_abstract_declarator attribute_specifier_sequence
        | function_abstract_declarator attribute_specifier_sequence
        ;

array_abstract_declarator
        : '[' ']'
        | '[' '*' ']'
        | '[' STATIC type_qualifier_list assignment_expression ']'
        | '[' STATIC assignment_expression ']'
        | '[' type_qualifier_list STATIC assignment_expression ']'
        | '[' type_qualifier_list assignment_expression ']'
        | '[' type_qualifier_list ']'
        | '[' assignment_expression ']'
        | direct_abstract_declarator '[' ']'
        | direct_abstract_declarator '[' '*' ']'
        | direct_abstract_declarator '[' STATIC type_qualifier_list assignment_expression ']'
        | direct_abstract_declarator '[' STATIC assignment_expression ']'
        | direct_abstract_declarator '[' type_qualifier_list STATIC assignment_expression ']'
        | direct_abstract_declarator '[' type_qualifier_list assignment_expression ']'
        | direct_abstract_declarator '[' type_qualifier_list ']'
        | direct_abstract_declarator '[' assignment_expression ']'
        ;

function_abstract_declarator
        : '(' ')'
        | '(' parameter_type_list ')'
        | direct_abstract_declarator '(' ')'
        | direct_abstract_declarator '(' parameter_type_list ')'
        ;

/* 6.7.9 Type definitions */


typedef_name
        : TYPEDEF_NAME
        ;


/* 6.7.10 Type inference */
/* this section defines no syntax */

/* 6.7.11 Initialization */

initializer
        : braced_initializer
        | assignment_expression
        ;

braced_initializer
        : '{' '}'
        | '{' initializer_list '}'
        | '{' initializer_list ',' '}'
        ;

initializer_list
        : designation initializer
        | initializer
        | initializer_list ',' designation initializer
        | initializer_list ',' initializer
        ;

designation
        : designator_list '='
        ;

designator_list
        : designator
        | designator_list designator
        ;

designator
        : '[' constant_expression ']'
        | '.' identifier
        ;

/* 6.7.12 Static assertions */

static_assert_declaration
        : STATIC_ASSERT '(' constant_expression ',' string_literal ')'
        | STATIC_ASSERT '(' constant_expression ')'
        ;
//END_MAIN_GRAMMAR
//START_ATTRIBUTES_GRAMMAR
/* 6.7.13 Attributes */
/* 6.7.13.1 Introduction */
/* this section defines no syntax */
/* 6.7.13.2 General */

attribute_specifier_sequence
        : attribute_specifier
        | attribute_specifier_sequence attribute_specifier
        ;

attribute_specifier
//        : '[' '[' attribute_list ']' ']'
        : ATTRIBUTE_HACK attribute_list ']' ']'
        ;

attribute_list
        : attribute
        | attribute_list ',' attribute
        ;

attribute
        : attribute_token
        | attribute_token attribute_argument_clause
        ;

attribute_token
        : standard_attribute
        | attribute_prefixed_token
        ;

standard_attribute
        : identifier
        ;

attribute_prefixed_token
        : attribute_prefix "::" identifier
        ;

attribute_prefix
        : identifier
        ;

attribute_argument_clause
        : '(' ')'
        | '(' balanced_token_sequence ')'
        ;

balanced_token_sequence
        : balanced_token
        | balanced_token_sequence balanced_token
        ;

balanced_token
        : '(' ')'
        | '[' ']'
        | '{' '}'
        | '(' balanced_token_sequence ')'
        | '[' balanced_token_sequence ']'
        | '{' balanced_token_sequence '}'
        | "ATTR_TOKEN" /*any token other than a parenthesis, a bracket, or a brace*/
        ;
//END_ATTRIBUTES_GRAMMAR
/* 6.7.13.3 The nodiscard attribute */
/* this section defines no syntax */
/* 6.7.13.4 The maybe_unused attribute */
/* this section defines no syntax */
/* 6.7.13.5 The deprecated attribute */
/* this section defines no syntax */
/* 6.7.13.6 The fallthrough attribute */
/* this section defines no syntax */
/* 6.7.13.7 The noreturn and _Noreturn attributes */
/* this section defines no syntax */
/* 6.7.13.8 Standard attributes for function types */
/* 6.7.13.8.1 General */
/* this section defines no syntax.  It does define two identifiers for function type attributes: unsequenced reproducible */
/* 6.7.13.8.2 The reproducible type attribute */
/* this section defines no syntax */
/* 6.7.13.8.3 The unsequenced type attribute */
/* this section defines no syntax */

/* 6.8 Statements and blocks */
/* 6.8.1 General */

statement
        : labeled_statement
        | unlabeled_statement
        ;

unlabeled_statement
        : expression_statement
        | primary_block
        | jump_statement
        | attribute_specifier_sequence primary_block
        | attribute_specifier_sequence jump_statement
        ;

primary_block
        : compound_statement
        | selection_statement
        | iteration_statement
        ;

secondary_block
        : statement
        ;

/* 6.8.2 Labeled statements */

label
        : identifier ':'
        | CASE constant_expression ':'
        | DEFAULT ':'
        | attribute_specifier_sequence identifier ':'
        | attribute_specifier_sequence CASE constant_expression ':'
        | attribute_specifier_sequence DEFAULT ':'
        ;

labeled_statement
        : label statement
        ;

/* 6.8.3 Compound statement */

compound_statement
        : '{' '}'
        | '{' block_item_list '}'
        ;

block_item_list
        : block_item
        | block_item_list block_item
        ;

block_item
        : declaration
        | unlabeled_statement
        | label
        ;

/* 6.8.4 Expression and null statements */

expression_statement
        : ';'
        | expression ';'
        | attribute_specifier_sequence expression ';'
        ;

/* 6.8.5 Selection statements */
/* 6.8.5.1 General */

selection_statement
        : IF '(' expression ')' secondary_block
        | IF '(' expression ')' secondary_block ELSE secondary_block
        | IF expression compound_statement
        | IF expression compound_statement ELSE compound_statement
        | SWITCH '(' expression ')' secondary_block
        ;

/* 6.8.5.2 The if statement */
/* This section defines no syntax */
/* 6.8.5.3 The switch statement */
/* This section defines no syntax */

/* 6.8.6 Iteration statements */
/* 6.8.6.1 General */

iteration_statement
        : WHILE '(' expression ')' secondary_block
        | DO secondary_block WHILE '(' expression ')' ';'
        | FOR '(' expression ';' expression ';' expression ')' secondary_block
        | FOR '(' expression ';' expression ';' ')' secondary_block
        | FOR '(' expression ';' ';' expression ')' secondary_block
        | FOR '(' expression ';' ';' ')' secondary_block
        | FOR '(' ';' expression ';' expression ')' secondary_block
        | FOR '(' ';' expression ';' ')' secondary_block
        | FOR '(' ';' ';' expression ')' secondary_block
        | FOR '(' ';' ';' ')' secondary_block
        | FOR '(' declaration expression ';' expression ')' secondary_block
        | FOR '(' declaration expression ';' ')' secondary_block
        | FOR '(' declaration ';' expression ')' secondary_block
        | FOR '(' declaration ';' ')' secondary_block
        ;

/* 6.8.6.2 The while statement */
/* This section defines no syntax */
/* 6.8.6.3 The do statement */
/* This section defines no syntax */
/* 6.8.6.4 The for statement */
/* This section defines no syntax */

/* 6.8.7 Jump statements */
/* 6.8.7.1 General */

jump_statement
        : GOTO identifier ';'
        | CONTINUE ';'
        | BREAK ';'
        | RETURN ';'
        | RETURN expression ';'
        ;

/* 6.8.7.2 The goto statement */
/* This section defines no syntax */
/* 6.8.7.3 The continue statement */
/* This section defines no syntax */
/* 6.8.7.4 The break statement */
/* This section defines no syntax */
/* 6.8.7.5 The return statement */
/* This section defines no syntax */
/* 6.9 External definitions */
/* 6.9.1 General */

translation_unit
        : external_declaration
        | translation_unit external_declaration
        ;

external_declaration
        : function_definition
        | declaration
        ;

/* 6.9.2 Function definitions */

function_definition
        : declaration_specifiers declarator function_body
        | attribute_specifier_sequence declaration_specifiers declarator function_body
        ;

function_body
        : compound_statement
        ;

/* 6.9.3 External object definitions */
/* This section defines no syntax */

//START_PREPROCESSING_GRAMMAR
// /* 6.10 Preprocessing directives */
// preprocessing_file:
//  group_opt
// ;
// group_opt:
// | group
// ;
// group:
//  group_part
// | group group_part
// ;
// group_part:
//  if_section
// | control_line
// | text_line
// | '#' non_directive
// ;
// if_section:
//  if_group elif_groups_opt else_group_opt endif_line
// ;
// if_group:
//  '#' "if" constant_expression new_line group_opt
// | '#' "ifdef" identifier new_line group_opt
// | '#' "ifndef" identifier new_line group_opt
// ;
// elif_groups_opt:
// | elif_groups
// ;
// elif_groups:
//  elif_group
// | elif_groups elif_group
// ;
// elif_group:
//  '#' "elif" constant_expression new_line group_opt
// | '#' "elifdef" identifier new_line group_opt
// | '#' "elifndef" identifier new_line group_opt
// ;
// else_group_opt:
// | else_group
// ;
// else_group:
//  '#' "else" new_line group_opt
// ;
// endif_line:
//  '#' "endif" new_line
// ;
// control_line:
//  '#' "include" pp_tokens new_line
// | '#' "embed" pp_tokens new_line
// | '#' "define" identifier replacement_list new_line
// | '#' "define" identifier lparen identifier_list_opt ')' replacement_list new_line
// | '#' "define" identifier lparen "..." ')' replacement_list new_line
// | '#' "define" identifier lparen identifier_list ',' "..." ')' replacement_list new_line
// | '#' "undef" identifier new_line
// | '#' "line" pp_tokens new_line
// | '#' "error" pp_tokens_opt new_line
// | '#' "warning" pp_tokens_opt new_line
// | '#' "pragma" pp_tokens_opt new_line
// | '#' new_line
// ;
// text_line:
//  pp_tokens_opt new_line
// ;
// non_directive:
//  pp_tokens new_line
// ;
// lparen:
// '(' /*a '(' character not immediately preceded by white space*/
// ;
// replacement_list:
//  pp_tokens_opt
// ;
// pp_tokens_opt:
// | pp_tokens
// ;
// pp_tokens:
//  preprocessing_token
// | pp_tokens preprocessing_token
// ;
// new_line:
//  '\n' /*the new_line character*/
// ;
// identifier_list_opt:
// | identifier_list
// ;
// identifier_list:
//  identifier
// | identifier_list ',' identifier
// ;
// pp_parameter:
//  pp_parameter_name pp_parameter_clause_opt
// ;
// pp_parameter_name:
//  pp_standard_parameter
// | pp_prefixed_parameter
// ;
// pp_standard_parameter:
//  identifier
// ;
// pp_prefixed_parameter:
//  identifier "::" identifier
// ;
// pp_parameter_clause_opt:
// | pp_parameter_clause
// ;
// pp_parameter_clause:
//  '(' pp_balanced_token_sequence_opt ')'
// ;
// pp_balanced_token_sequence_opt:
// | pp_balanced_token_sequence
// ;
// pp_balanced_token_sequence:
//  pp_balanced_token
// | pp_balanced_token_sequence pp_balanced_token
// ;
// pp_balanced_token:
// '(' pp_balanced_token_sequence_opt ')'
// | '[' pp_balanced_token_sequence_opt ']'
// | '{' pp_balanced_token_sequence_opt '}'
// | /*any pp_token other than a parenthesis, a bracket, or a brace*/
// ;
// embed_parameter_sequence_opt:
// | embed_parameter_sequence
// ;
// embed_parameter_sequence:
// pp_parameter
// | embed_parameter_sequence pp_parameter
// ;
// 
// /* 6.10.2 Conditional inclusion */
// defined_macro_expression:
// | "defined" identifier
// | "defined" '(' identifier ')'
// ;
// h_preprocessing_token:
// | /*any preprocessing_token other than >*/
// ;
// h_pp_tokens:
// h_preprocessing_token
// | h_pp_tokens h_preprocessing_token
// ;
// header_name_tokens:
// string_literal
// | '<' h_pp_tokens '>'
// ;
// has_include_expression:
// "__has_include" '(' header_name ')'
// | "__has_include" '(' header_name_tokens ')'
// ;
// header_name: HEADER_NAME
// ;
// has_embed_expression:
// "__has_embed" '(' header_name embed_parameter_sequence_opt ')'
// | "__has_embed" '(' header_name_tokens pp_balanced_token_sequence_opt ')'
// ;
// has_c-attribute_express:
// "__has_c_attribute" '(' pp_tokens ')'
// ;
// 
// /* 6.10.3 Source file inclusion */
// /* This section defines no syntax */
// /* 6.10.4 Binary resource inclusion */
// /* 6.10.4.1 #embed preprocessing directive */
// /* This section defines no syntax */
// /* 6.10.4.2 limit parameter */
// /* This section defines no syntax */
// /* 6.10.4.3 suffix parameter */
// /* This section defines no syntax */
// /* 6.10.4.4 prefix parameter */
// /* This section defines no syntax */
// /* 6.10.4.5 if_empty parameter */
// /* This section defines no syntax */
// 
// /* 6.10.5 Macro replacement */
// /* 6.10.5.1 Argument substitution */
// va_opt_replacement:
// "__VA_OPT__" '(' pp_tokens_opt ')'
// ;
// /* 6.10.5.2 The # operator */
// /* This section defines no syntax */
// /* 6.10.5.3 The ## operator */
// /* This section defines no syntax */
// /* 6.10.5.4 Rescanning and further replacement */
// /* This section defines no syntax */
// /* 6.10.5.5 Scope of macro definitions */
// /* This section defines no syntax */
// 
// /* 6.10.6 Line control */
// /* This section defines no syntax */
// /* 6.10.7 Diagnostic directives */
// /* This section defines no syntax */
// 
// /* 6.10.8 Pragma directive */
// standard_pragma:
// | '#' "pragma" "STDC" "FP_CONTRACT" on_off_switch
// | '#' "pragma" "STDC" "FENV_ACCESS" on_off_switch
// | '#' "pragma" "STDC" "FENV_DEC_ROUND" dec_direction
// | '#' "pragma" "STDC" "FENV_ROUND" direction
// | '#' "pragma" "STDC" "CX_LIMITED_RANGE" on_off_switch
// ;
// on_off_switch: | "ON" | "OFF" | "DEFAULT"
// ;
// direction:
//  "FE_DOWNWARD" | "FE_TONEAREST" | "FE_TONEARESTFROMZERO"
// | "FE_TOWARDZERO" | "FE_UPWARD" | "FE_DYNAMIC"
// ;
// dec_direction:
//  "FE_DEC_DOWNWARD" | "FE_DEC_TONEAREST" | "FE_DEC_TONEARESTFROMZERO"
// | "FE_DEC_TOWARDZERO" | "FE_DEC_UPWARD" | "FE_DEC_DYNAMIC"
// ;
// 
// /* 6.10.9 Null directive */
// /* This section defines no syntax */
// 
// /* 6.10.9 Predefined macro names */
// /* This section defines no syntax */
//END_PREPROCESSING_GRAMMAR
//START_FLOATING_POINT_SEQ_GRAMMAR 
// /* A.5 Floating-point subject sequence */
// /* A.5.1 NaN char sequence */
// /* 7.24.1.5 */
// n_char_sequence:
//  digit
// | nondigit
// | n_char_sequence digit
// | n_char_sequence nondigit
// ;
// /* A.5.2 NaN wchar_t sequence */
// /* 7.31.4.1.2 */
// n_wchar_sequence:
//  digit
// | nondigit
// | n_wchar_sequence digit
// | n_wchar_sequence nondigit
// ;
// /* A.6 Decimal floating-point subject sequence */
// /* A.6.1 NaN decimal char sequence */
// /* 7.24.1.6 */
// d_char_sequence:
// | digit
// | nondigit
// | d_char_sequence digit
// | d_char_sequence nondigit
// ;
// /* A.6.2 NaN decimal wchar_t sequence */
// /* 7.31.4.1.3 */
// d_wchar_sequence:
//  digit
// | nondigit
// | d_wchar_sequence digit
// | d_wchar_sequence nondigit
// ;
//END_FLOATING_POINT_SEQ_GRAMMAR
%%
#include "yyreport_syntax_error.c"
/*
#include <stdio.h>

void yyerror(const char *s)
{
	fflush(stdout);
	fprintf(stderr, "*** %s\n", s);
}
*/


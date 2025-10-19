%{
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

extern struct Node* root;
%}

%token	SIZEOF
%token	PTR_OP INC_OP DEC_OP 
%token	MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token	SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token	XOR_ASSIGN OR_ASSIGN
%token	TYPEDEF_NAME

%token	TYPEDEF EXTERN STATIC AUTO REGISTER INLINE
%token	CONST RESTRICT VOLATILE
%token	CHAR SHORT LONG SIGNED UNSIGNED VOID
%token	COMPLEX IMAGINARY 
%token	STRUCT UNION ENUM ELLIPSIS

%token	CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token	ALIGNAS ALIGNOF ATOMIC NORETURN STATIC_ASSERT THREAD_LOCAL

%start translation_unit
%union {
	int intval;
	float floatval;
	double doubleval;
	char *id; // magic that works
	// char charval;
    struct Node* node;
    enum yytokentype yyt_type;
}
%token <yyt_type> INT FLOAT
%token <id> IDENTIFIER STRING_LITERAL ENUMERATION_CONSTANT FUNC_NAME GENERIC
%token <intval> INT_CONST I_CONSTANT
%token <floatval> FLOAT_CONST F_CONSTANT
%token <doubleval> DOUBLE_CONST DOUBLE
%token <boolval> BOOL
// %token <charval> '*' '/' '%' '+' '-' '<' '>' '&' '^' '|' '~' '!' '=' ';' ',' ':' '?' '(' ')' '{' '}' '[' ']'
%token <intval> LE_OP GE_OP EQ_OP NE_OP AND_OP OR_OP LEFT_OP RIGHT_OP
%type <node> primary_expression expression generic_selection type_specifier declaration_specifiers declaration translation_unit external_declaration enumeration_constant
%type <node> constant init_declarator init_declarator_list direct_declarator declarator initializer initializer_list assignment_expression conditional_expression 
%type <node> unary_expression postfix_expression cast_expression logical_or_expression logical_and_expression exclusive_or_expression inclusive_or_expression and_expression
%type <node> multiplicative_expression additive_expression shift_expression  constant_expression equality_expression relational_expression expression_statement
%type <node> block_item block_item_list compound_statement statement labeled_statement selection_statement iteration_statement jump_statement
%type <id> string
%%
primary_expression
	: IDENTIFIER { $$ = make_identifier_node($1); }
	| constant { $$ = $1; }
	| string { $$ = make_identifier_node($1); }
	| '(' expression ')' { $$ = $2; }
	| generic_selection 
	;

constant
	: I_CONSTANT { $$ = make_constant_node($1); }		/* includes character_constant */
	| F_CONSTANT { $$ = make_constant_node($1); }
	| ENUMERATION_CONSTANT { $$ = make_identifier_node($1); }	/* after it has been defined as such */
	;

enumeration_constant		/* before it has been defined as such */
	: IDENTIFIER { $$ = make_identifier_node($1); }
	;

string
	: STRING_LITERAL { zig_error(); }
	| FUNC_NAME { zig_error(); }
	;

generic_selection
	: GENERIC '(' assignment_expression ',' generic_assoc_list ')' { zig_error(); }
	;

generic_assoc_list
	: generic_association
	| generic_assoc_list ',' generic_association
	;

generic_association
	: type_name ':' assignment_expression
	| DEFAULT ':' assignment_expression
	;

postfix_expression
	: primary_expression 
	/*| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' '{' initializer_list '}'
	| '(' type_name ')' '{' initializer_list ',' '}' */
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression
/*| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	| ALIGNOF '(' type_name ')'*/
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression
	//| '(' type_name ')' cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression { $$ = make_binary_node($1, '*', $3);}
	| multiplicative_expression '/' cast_expression { $$ = make_binary_node($1, '/', $3);}
	| multiplicative_expression '%' cast_expression { $$ = make_binary_node($1, '%', $3);}
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression { $$ = make_binary_node($1, '+', $3);}
	| additive_expression '-' multiplicative_expression { $$ = make_binary_node($1, '-', $3);}
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression { $$ = make_conditional_expression_node($1, $2, $3);}
	| shift_expression RIGHT_OP additive_expression { $$ = make_conditional_expression_node($1, $2, $3);}
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression { $$ = make_binary_node($1, '<', $3);}
	| relational_expression '>' shift_expression { $$ = make_binary_node($1, '>', $3);}
	| relational_expression LE_OP shift_expression { $$ = make_conditional_expression_node($1, $2, $3);}
	| relational_expression GE_OP shift_expression { $$ = make_conditional_expression_node($1, $2, $3);}
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression { $$ = make_conditional_expression_node($1, $2, $3);}
	| equality_expression NE_OP relational_expression { $$ = make_conditional_expression_node($1, $2, $3);}
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression { $$ = make_binary_node($1, '&', $3); }
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression { $$ = make_binary_node($1, '^', $3);}
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression { $$ = make_binary_node($1, '|', $3);}
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression { $$ = make_conditional_expression_node($1, $2, $3);}
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression { $$ = make_conditional_expression_node($1, $2, $3);}
	;

conditional_expression
	: logical_or_expression
	// | logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	// | unary_expression assignment_operator assignment_expression
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

expression
	: assignment_expression { zig_error(); }
	| expression ',' assignment_expression { zig_error(); }
	;

constant_expression
	: conditional_expression	/* with constraints */
	;

declaration
	: declaration_specifiers ';' { $$ = make_declaration_node($1, NULL); }
	| declaration_specifiers init_declarator_list ';' { $$ = make_declaration_node($1, $2); }
	| static_assert_declaration { zig_error(); }
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers { zig_error(); }
	| storage_class_specifier { zig_error(); }
	| type_specifier declaration_specifiers
	| type_specifier 
	| type_qualifier declaration_specifiers { zig_error(); }
	| type_qualifier { zig_error(); }
	| function_specifier declaration_specifiers { zig_error(); }
	| function_specifier { zig_error(); }
	| alignment_specifier declaration_specifiers { zig_error(); }
	| alignment_specifier { zig_error(); }
	;

init_declarator_list
	: init_declarator 
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator '=' initializer { $$ = make_assignment_node($1, $3); }
	| declarator {$$ = make_assignment_node($1, NULL); }
	;

storage_class_specifier
	: TYPEDEF	/* identifiers must be flagged as TYPEDEF_NAME */
	| EXTERN
	| STATIC
	| THREAD_LOCAL
	| AUTO
	| REGISTER
	;

type_specifier
	: VOID { 
        $$ = make_type_node(VOID);
    }
	| CHAR { 
        $$ = make_type_node(CHAR);
    }
	| SHORT { 
        $$ = make_type_node(SHORT);
    }
	| INT { 
        $$ = make_type_node(INT);
    }
	| LONG { 
        $$ = make_type_node(LONG);
    }
	| FLOAT { 
        $$ = make_type_node(FLOAT);
    }
	| DOUBLE { 
        $$ = make_type_node(DOUBLE);
    }
	| SIGNED { 
        $$ = make_type_node(SIGNED);
    }
	| UNSIGNED { 
        $$ = make_type_node(UNSIGNED);
    }
	| BOOL { 
        $$ = make_type_node(BOOL);
    }
	| COMPLEX { 
        $$ = make_type_node(COMPLEX);
    }
	| IMAGINARY{ 
        $$ = make_type_node(IMAGINARY);
    }	/* non-mandated extension */
	| atomic_type_specifier { zig_error(); }
	| struct_or_union_specifier { zig_error(); }
	| enum_specifier { zig_error(); }
	| TYPEDEF_NAME { zig_error(); }		/* after it has been defined as such */
	;

struct_or_union_specifier
	: struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list ';'	/* for anonymous struct/union */
	| specifier_qualifier_list struct_declarator_list ';'
	| static_assert_declaration
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: ':' constant_expression
	| declarator ':' constant_expression
	| declarator
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM '{' enumerator_list ',' '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list ',' '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator	/* identifiers must be flagged as ENUMERATION_CONSTANT */
	: enumeration_constant '=' constant_expression
	| enumeration_constant
	;

atomic_type_specifier
	: ATOMIC '(' type_name ')'
	;

type_qualifier
	: CONST
	| RESTRICT
	| VOLATILE
	| ATOMIC
	;

function_specifier
	: INLINE
	| NORETURN
	;

alignment_specifier
	: ALIGNAS '(' type_name ')'
	| ALIGNAS '(' constant_expression ')'
	;

declarator
	/*: pointer direct_declarator */
	: direct_declarator
	;

direct_declarator
	: IDENTIFIER { $$ = make_identifier_node($1); }
	| '(' declarator ')' { $$ = $2; }
	| direct_declarator '[' ']'
	| direct_declarator '[' '*' ']'
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_declarator '[' STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list '*' ']'
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list ']'
	| direct_declarator '[' assignment_expression ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' ')'
	| direct_declarator '(' identifier_list ')'
	;

pointer
	: '*' type_qualifier_list pointer
	| '*' type_qualifier_list
	| '*' pointer
	| '*'
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list ',' ELLIPSIS
	| parameter_list
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

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
	| '[' ']'
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
	| direct_abstract_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_abstract_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_abstract_declarator '[' type_qualifier_list ']'
	| direct_abstract_declarator '[' assignment_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: '{' initializer_list '}' { $$ = $2; }
	| '{' initializer_list ',' '}' { $$ = $2; }
	| assignment_expression
	;

initializer_list
	/*: designation initializer*/
	: initializer
	/*| initializer_list ',' designation initializer
	| initializer_list ',' initializer */
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
	| '.' IDENTIFIER
	;

static_assert_declaration
	: STATIC_ASSERT '(' constant_expression ',' STRING_LITERAL ')' ';'
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{' '}'
	| '{'  block_item_list '}'
	;

block_item_list
	: block_item { $$ = append_block_list($1, NULL)}
	| block_item_list block_item { $$ = append_block_list($2, $1); }
	;

block_item
	: declaration
	| statement
	;

expression_statement
	: ';'
	| expression ';' { $$ = make_expr_stmt($1); }
	;

selection_statement
	: IF '(' expression ')' statement ELSE statement 
	| IF '(' expression ')' statement
    | IF expression compound_statement ELSE compound_statement
    | IF expression compound_statement
	| SWITCH '(' expression ')' statement
	| SWITCH expression compound_statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	: WHILE expression compound_statement
	| DO statement WHILE '(' expression ')' ';'
    | FOR expression_statement expression_statement compound_statement
    | FOR expression_statement expression_statement expression_statement compound_statement
    | FOR declaration expression_statement expression compound_statement
    | FOR declaration expression_statement compound_statement
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	| FOR '(' declaration expression_statement ')' statement
	| FOR '(' declaration expression_statement expression ')' statement
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;

translation_unit
	: external_declaration { 
        printf("[DEBUG] Assigning Root External_Declaration\n");
        fflush(stdout);
        root = $1; 
    }
	| translation_unit external_declaration
	;

external_declaration
	: function_definition { zig_error(); }
	| declaration { printf("[DEBUG] Finished Declaration Rule\n"); fflush(stdout); }
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement { zig_error(); }
	| declaration_specifiers declarator compound_statement { zig_error(); }
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

%%

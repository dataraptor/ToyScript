%define parse.error verbose /* instruct bison to generate verbose error messages*/
%parse-param {struct AstElement **astDest} 

%{

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#define YYDEBUG 1
#define YYPARSE_PARAM astDest

int yylex();


struct AstElement
{
    enum {	
    		ekId = 0,
    		ekNumber = 1,
    		ekBinExpression = 2,
    		ekPrefixUnaryExpression = 3,
    		ekPostfixUnaryExpression = 4,
    		ekCall = 5,
    		
    		ekAssignment = 6,
    		ekIf = 7,
    		ekSwitch = 8,
    		ekFor = 9,
    		ekWhile = 10,
    		ekDoWhile = 11,
    		
    		ekPrint = 12,
    		ekStatements = 13,
    		ekLastElement = 14,
    		
    		ekElseIf = 201,
    		ekElse = 202,
    		ekCase = 203,
    		ekDefault = 204
    		
    } kind;
    union
    {
        int val;
        char* name;
        struct
        {
            struct AstElement *left, *right;
            char op;
        }expression;
        struct
        {
            char*name;
            struct AstElement* right;
        }assignment;
        struct
        {
            int count;
            struct AstElement** statements;
        }statements;
        struct
        {
        		struct AstElement* init;
            struct AstElement* cond;
            struct AstElement* post;
            struct AstElement* statements;
        } forStmt;
        struct
        {
            struct AstElement* cond;
            struct AstElement* statements;
        } whileStmt;
        struct
        {
            struct AstElement* cond;
            struct AstElement* statements;
        } dowhileStmt;
        struct
        {
            struct AstElement* cond;
            struct AstElement* statements;
            struct AstElement* right;    // Next condition (else if, else)
        } ifStmt;
        struct
        {
            struct AstElement* cond;					// Holds var of switch, cond for case 
            struct AstElement* statements;		// Internal statements of case
            struct AstElement* right;					// Next case statement
            char _break;
        } switchStmt;
        struct
        {
            char* name;
            struct AstElement* param;
        }call;
        struct
        {
            char* str;
            struct AstElement* param;
            char endl;												 // New line
        }printStmt;
    } data;
};

struct AstElement* makeAssignment(char*name, struct AstElement* val);
struct AstElement* makeExpByNum(int val);
struct AstElement* makeExpByName(char*name);
struct AstElement* makeExp(struct AstElement* left, struct AstElement* right, char op);
struct AstElement* makePrefixUnaryOp(char*name, char op);
struct AstElement* makePostfixUnaryOp(char*name, char op);
struct AstElement* makeStatement(struct AstElement* dest, struct AstElement* toAppend);
struct AstElement* makeFor(struct AstElement* init, struct AstElement* cond, struct AstElement* post, struct AstElement* exec);
struct AstElement* makeWhile(struct AstElement* cond, struct AstElement* exec);
struct AstElement* makeDoWhile(struct AstElement* cond, struct AstElement* exec);
struct AstElement* makeIf(struct AstElement* cond,struct AstElement* exec,struct AstElement* elseifStmt,struct AstElement* elseStmt);
struct AstElement* makeElseIf(struct AstElement* prev, struct AstElement* cond, struct AstElement* exec);
struct AstElement* makeElse(struct AstElement* exec);
struct AstElement* makeSwitch(struct AstElement* var, struct AstElement* caseStmt, struct AstElement* defaultStmt);
struct AstElement* makeCase(struct AstElement* prev, struct AstElement* cond, struct AstElement* exec, char _break);
struct AstElement* makeDefault(struct AstElement* exec);
struct AstElement* makeCall(char* name, struct AstElement* param);
struct AstElement* makePrint(char* str, struct AstElement* param, char endl);



static void* checkAlloc(size_t sz) {
    void* result = calloc(sz, 1);
    if(!result) {
        fprintf(stderr, "alloc failed\n");
        exit(1);
    }
}

struct AstElement* makeAssignment( char*name, struct AstElement* val) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekAssignment;
    result->data.assignment.name = name;
    result->data.assignment.right = val;
    return result;
}

struct AstElement* makeExpByNum(int val) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekNumber;
    result->data.val = val;
    return result;
}

struct AstElement* makeExpByName(char*name) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekId;
    result->data.name = name;
    return result;
}

struct AstElement* makeExp(struct AstElement* left, struct AstElement* right, char op) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekBinExpression;
    result->data.expression.left = left;
    result->data.expression.right = right;
    result->data.expression.op = op;
    return result;
}

struct AstElement* makePrefixUnaryOp(char*name, char op) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekPrefixUnaryExpression;
    result->data.name = name;
    result->data.expression.op = op;
    return result;
}

struct AstElement* makePostfixUnaryOp(char*name, char op) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekPostfixUnaryExpression;
    result->data.name = name;
    result->data.expression.op = op;
    return result;
}

struct AstElement* makeCall(char* name, struct AstElement* param) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekCall;
    result->data.call.name = name;
    result->data.call.param = param;
    return result;
}

struct AstElement* makeStatement(struct AstElement* result, struct AstElement* toAppend) {
    if(!result) {
        result = checkAlloc(sizeof(*result));
        result->kind = ekStatements;
        result->data.statements.count = 0;
        result->data.statements.statements = 0;
    }
    assert(ekStatements == result->kind);
    result->data.statements.count++;
    result->data.statements.statements = realloc(result->data.statements.statements, 
    	result->data.statements.count*sizeof(*result->data.statements.statements)
    );
    result->data.statements.statements[result->data.statements.count-1] = toAppend;
    return result;
}

struct AstElement* makeFor(struct AstElement* init, struct AstElement* cond, 
		struct AstElement* post, struct AstElement* exec
){
		struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekFor;
    result->data.forStmt.init = init;
    result->data.forStmt.cond = cond;
    result->data.forStmt.post = post;
    result->data.forStmt.statements = exec;
    return result;
}

struct AstElement* makeWhile(struct AstElement* cond, struct AstElement* exec) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekWhile;
    result->data.whileStmt.cond = cond;
    result->data.whileStmt.statements = exec;
    return result;
}

struct AstElement* makeDoWhile(struct AstElement* cond, struct AstElement* exec) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekWhile;
    result->data.dowhileStmt.cond = cond;
    result->data.dowhileStmt.statements = exec;
    return result;
}

struct AstElement* makeIf(
		struct AstElement* cond,
		struct AstElement* exec,
		struct AstElement* elseifStmt, 
		struct AstElement* elseStmt
) {
		struct AstElement* result = checkAlloc(sizeof(*result));
		result->kind = ekIf;
		result->data.ifStmt.cond = cond;
		result->data.ifStmt.statements = exec;
		if(elseifStmt) result->data.ifStmt.right = elseifStmt;
		if(elseStmt) {
				// Get last node
				
				struct AstElement* tmp = result;
				while(tmp->data.ifStmt.right){
						tmp = tmp->data.ifStmt.right;
				}
				
				//printf("elseStmt not null  %d\n", tmp->kind);
				tmp->data.ifStmt.right = elseStmt;
		}
		
		//printf("makeIf\n");
		return result;
}



struct AstElement* makeElseIf(struct AstElement* prev, struct AstElement* cond, struct AstElement* exec) {
		if(!prev) {
			prev = checkAlloc(sizeof(*prev));
			prev->kind = ekElseIf;
      prev->data.ifStmt.cond = cond;
      prev->data.ifStmt.statements = exec;
      //printf("makeElseIf first\n");
      return prev;
		}
		
		// get last node
		struct AstElement* tmp = prev;
		while(tmp->data.ifStmt.right){
			tmp = tmp->data.ifStmt.right;
		}
		
		struct AstElement* result = checkAlloc(sizeof(*result));
		result->kind = ekElseIf;
		result->data.ifStmt.cond = cond;
		result->data.ifStmt.statements = exec;
		tmp->data.ifStmt.right = result;
		
		//printf("makeElseIf\n");
		return prev;
}

struct AstElement* makeElse(struct AstElement* exec) {
		struct AstElement* result = checkAlloc(sizeof(*result));
		result->kind = ekElse;
		result->data.ifStmt.statements = exec;
		//printf("makeElse\n");
		return result;
}


struct AstElement* makeSwitch(struct AstElement* var, struct AstElement* caseStmt, struct AstElement* defaultStmt) {
		struct AstElement* result = checkAlloc(sizeof(*result));
		result->kind = ekSwitch;
		result->data.switchStmt.cond = var;
		if(caseStmt) result->data.switchStmt.right = caseStmt;
		if(defaultStmt) {
				// Get last node
				struct AstElement* tmp = result;
				while(tmp->data.switchStmt.right){
						tmp = tmp->data.switchStmt.right;
				}
				
				//printf("defaultStmt not null  %d\n", tmp->kind);
				tmp->data.switchStmt.right = defaultStmt;
		}
		
		//printf("makeCase\n");
		return result;
}

struct AstElement* makeCase(struct AstElement* prev, struct AstElement* cond, struct AstElement* exec, char _break) {
		if(!prev) {
			prev = checkAlloc(sizeof(*prev));
			prev->kind = ekCase;
      prev->data.switchStmt.cond = cond;
      prev->data.switchStmt.statements = exec;
      prev->data.switchStmt._break = _break;
      //printf("makeCase first\n");
      return prev;
		}
		
		// get last node
		struct AstElement* tmp = prev;
		while(tmp->data.switchStmt.right){
			tmp = tmp->data.switchStmt.right;
		}
		
		struct AstElement* result = checkAlloc(sizeof(*result));
		result->kind = ekCase;
		result->data.switchStmt.cond = cond;
		result->data.switchStmt.statements = exec;
		result->data.switchStmt._break = _break;
		tmp->data.switchStmt.right = result;
		
		//printf("makeCase\n");
		return prev;
}

struct AstElement* makeDefault(struct AstElement* exec) {
		struct AstElement* result = checkAlloc(sizeof(*result));
		result->kind = ekDefault;
		result->data.switchStmt.statements = exec;
		return result;
}


struct AstElement* makePrint(char* str, struct AstElement* param, char endl) {
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekPrint;
    result->data.printStmt.str = str;
    result->data.printStmt.param = param;
    result->data.printStmt.endl = endl;
    return result;
}




/*Interpreter ---------------------------*/

struct AstElement;
struct ExecEnviron;

/* creates the execution engine */
struct ExecEnviron* createEnv();

/* removes the ExecEnviron */
void freeEnv(struct ExecEnviron* e);

/* executes an AST */
void execAst(struct ExecEnviron* e, struct AstElement* a);




#define TABSIZE 12
struct var {
	char *name;
	int val;
};

struct ExecEnviron {
    int x; /* The value of the x variable, a real language would have some name->value lookup table instead */
    
    struct var values[TABSIZE];
};

static int execGetValue(struct ExecEnviron* e, const char *varname) {
	int i;
	for(i = 0; i < TABSIZE; i++) {
		char *name = e->values[i].name;
		if(name) {
			if(strcmp(name, varname) == 0) {
				//printf("Var Get: %s <- %d\n", e->values[i].name, e->values[i].val);
				return e->values[i].val;
			}
		}
		else break;
	}
	
	// Critical Error
	return 0;
}

static void execSetValue(struct ExecEnviron* e, const char *varname, int value) {
	int i;
	for(i = 0; i < TABSIZE; i++) {
		char *name = e->values[i].name;
		if(name) {
			if(strcmp(name, varname) == 0) {
				// Update variable
				e->values[i].val = value;
				//printf("Var Update: %s <- %d\n", e->values[i].name, e->values[i].val);
				return;
			}
		}
		else {
			// Allocate space for variable
			e->values[i].name = strdup(varname);
			e->values[i].val = value;
			//printf("Var Assign: %s <- %d\n", e->values[i].name, e->values[i].val);
			return;
		}
	} 
	
	
	// CRITICAL Error: Not enough memory
}

static int execTermExpression(struct ExecEnviron* e, struct AstElement* a);
static int execBinExp(struct ExecEnviron* e, struct AstElement* a);
static int execUnaryPreExp(struct ExecEnviron* e, struct AstElement* a);
static int execUnaryPostExp(struct ExecEnviron* e, struct AstElement* a);
static int execCall(struct ExecEnviron* e, struct AstElement* a);
static void execAssign(struct ExecEnviron* e, struct AstElement* a);
static void execWhile(struct ExecEnviron* e, struct AstElement* a);
static void execDoWhile(struct ExecEnviron* e, struct AstElement* a);
static void execIf(struct ExecEnviron* e, struct AstElement* a);
static void execSwitch(struct ExecEnviron* e, struct AstElement* a);
static void execFor(struct ExecEnviron* e, struct AstElement* a);
static void execPrint(struct ExecEnviron* e, struct AstElement* a);
static void execStmt(struct ExecEnviron* e, struct AstElement* a);

/* Lookup Array for AST elements which yields values */
static int(*valExecs[])(struct ExecEnviron* e, struct AstElement* a) = {
    execTermExpression,
    execTermExpression,
    execBinExp,
    execUnaryPreExp,
    execUnaryPostExp,
    execCall,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
};

/* lookup array for non-value AST elements */
static void(*runExecs[])(struct ExecEnviron* e, struct AstElement* a) = {
    NULL, /* ID and numbers are canonical and */
    NULL, /* don't need to be executed */
    NULL, /* a binary expression is not executed */
    NULL,
    NULL,
    NULL,
    execAssign,
    execIf,
    execSwitch,
    execFor,
    execWhile,
    execDoWhile,
    execPrint,
    execStmt,
};

/* Dispatches any value expression */
static int dispatchExpression(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(valExecs[a->kind]);
    return valExecs[a->kind](e, a);
}

static void dispatchStatement(struct ExecEnviron* e, struct AstElement* a) {
    //assert(a);
    if(a == 0) return; 		//Skip if empty statement
    assert(runExecs[a->kind]);
    runExecs[a->kind](e, a);
}

static void onlyName(const char* name, const char* reference, const char* kind) {
    if(strcmp(reference, name)) {
        fprintf(stderr, "This language knows only the %s '%s', not '%s'\n",
            kind, reference, name
        );
        exit(1);
    }
}

static void onlyX(const char* name) {
    onlyName(name, "x", "variable");
}

static void onlyPrint(const char* name) {
    onlyName(name, "print", "function");
}

static int execTermExpression(struct ExecEnviron* e, struct AstElement* a) {
    /* This function looks ugly because it handles two different kinds of
     * AstElement. I would refactor it to an execNameExp and execVal
     * function to get rid of this two if statements. */
    assert(a);
    if(ekNumber == a->kind)  {
        return a->data.val;
    }
    else {
        if(ekId == a->kind) {
            // Get value of variable
            //onlyX(a->data.name);
            assert(e);
            
            return execGetValue(e, a->data.name);
            //return e->x;
        }
    }
    fprintf(stderr, "OOPS: tried to get the value of a non-expression(%d)\n", a->kind);
    exit(1);
}

static int execBinExp(struct ExecEnviron* e, struct AstElement* a) {
    assert(ekBinExpression == a->kind);
    const int left = dispatchExpression(e, a->data.expression.left);
    const int right = dispatchExpression(e, a->data.expression.right);
    switch(a->data.expression.op) {
        case '+':
            return left + right;
        case '-':
            return left - right;
        case '*':
            return left * right;
        case '/':
            return left / right;
        case '<':
            return left < right;
        case '>':
            return left > right;
        case '@':   									// >=
            return left >= right;
        case '#':											// <=
            return left <= right;
        case '$':											// equal
            return left == right;   
        case 'n':											// Not equal
            return left != right;   
        case '%':
            return left % right;
        case '&':
            return left && right;
        case '|':
            return left || right;
        case '^':
            return pow(left, right);
        default:
            fprintf(stderr,  "OOPS: Unknown operator:%c\n", a->data.expression.op);
            exit(1);
    }
    /* no return here, since every switch case returns some value (or bails out) */
}

static int execUnaryPreExp(struct ExecEnviron* e, struct AstElement* a) {
    assert(ekPrefixUnaryExpression == a->kind);
    
    int val = execGetValue(e, a->data.name);
    switch(a->data.expression.op) {
        case 'p':
            val=val+1;
            break;
        case 'm':
            val = val-1;
            break;
        case 'n':
            val = !val;
            break;
        default:
            fprintf(stderr,  "OOPS: Unknown operator:%c\n", a->data.expression.op);
            exit(1);
    }
    
    execSetValue(e, a->data.name, val);
    return val;
}

static int execUnaryPostExp(struct ExecEnviron* e, struct AstElement* a) {
    assert(ekPostfixUnaryExpression == a->kind);
    
    int val = execGetValue(e, a->data.name);
    int val_last = val;
    
    switch(a->data.expression.op) {
        case 'p':
            val=val+1;
            break;
        case 'm':
            val=val-1;
            break;
        default:
            fprintf(stderr,  "OOPS: Unknown operator:%c\n", a->data.expression.op);
            exit(1);
    }
    
    execSetValue(e, a->data.name, val);
    return val_last;
}


static int execCall(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekCall == a->kind);
    
    char *name = a->data.call.name;
    if(strcmp("sqrt", name) == 0) {
        return sqrt(dispatchExpression(e, a->data.call.param));
    }
    return 0;
}


static void execAssign(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekAssignment == a->kind);
    //onlyX(a->data.assignment.name);
    assert(e);
    struct AstElement* r = a->data.assignment.right;
    //e->x = dispatchExpression(e, r);
    
    //Store variable value
    execSetValue(e, a->data.assignment.name, dispatchExpression(e, r));
}

static void execFor(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekFor == a->kind);
    struct AstElement* const i = a->data.forStmt.init;
    struct AstElement* const c = a->data.forStmt.cond;
    struct AstElement* const p = a->data.forStmt.post;
    struct AstElement* const s = a->data.forStmt.statements;
    assert(c);
    //assert(s);
    for(dispatchStatement(e, i); dispatchExpression(e, c); dispatchStatement(e, p)) {
    		dispatchStatement(e, s);
    }
}

static void execWhile(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekWhile == a->kind);
    struct AstElement* const c = a->data.whileStmt.cond;
    struct AstElement* const s = a->data.whileStmt.statements;
    assert(c);
    //assert(s);
    while(dispatchExpression(e, c)) {
        dispatchStatement(e, s);
    }
}

static void execDoWhile(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekWhile == a->kind);
    struct AstElement* const c = a->data.whileStmt.cond;
    struct AstElement* const s = a->data.whileStmt.statements;
    assert(c);
    //assert(s);
    while(dispatchExpression(e, c)) {
        dispatchStatement(e, s);
    }
}

static void execIf(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekIf == a->kind);
    struct AstElement* const c = a->data.ifStmt.cond;
    struct AstElement* const s = a->data.ifStmt.statements;
    assert(c);
    //assert(s);
    if(dispatchExpression(e, c)) {
        dispatchStatement(e, s);
        return;
    }
    // Execute Else If, Else
    struct AstElement* rt = a;
    while(rt->data.ifStmt.right) {
    		rt = rt->data.ifStmt.right;
    		//printf("* %d\n", rt->kind);
    		
    		if(rt->kind == ekElseIf) {
    				struct AstElement* const cr = rt->data.ifStmt.cond;
    				struct AstElement* const sr = rt->data.ifStmt.statements;
    				
    				if(dispatchExpression(e, cr)) {
        			dispatchStatement(e, sr);
        			return;
    				}
    		}
    		else if(rt->kind == ekElse) {
    				struct AstElement* const sr = rt->data.ifStmt.statements;
    				dispatchStatement(e, sr);
    				return;
    		}
    }
}

static void execSwitch(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekSwitch == a->kind);
    struct AstElement* const c = a->data.switchStmt.cond;
    assert(c);
    //assert(s);
    int var = dispatchExpression(e, c);
    
    // Execute Cases
    struct AstElement* rt = a->data.switchStmt.right;
    while(rt) {
    		if(rt->kind == ekCase) {
    				if(dispatchExpression(e, rt->data.switchStmt.cond) == var) {
        				// Continue execution untill break found
        				while(rt) {
        						dispatchStatement(e, rt->data.switchStmt.statements);
        						if(rt->data.switchStmt._break) return;
        						rt = rt->data.switchStmt.right;
        				}
        				return;
    				}
    		}
    		else if(rt->kind == ekDefault) {
    				struct AstElement* const sr = rt->data.switchStmt.statements;
    				dispatchStatement(e, sr);
    				return;
    		}
    		rt = rt->data.switchStmt.right;
    }
}


static void execPrint(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekPrint == a->kind);
    char* s = a->data.printStmt.str;
    struct AstElement* const p = a->data.printStmt.param;
    //assert(c);
    //assert(s);
    
    if(s) {
    	if(p) printf(s, dispatchExpression(e, p));
    	else printf("%s", s);
    }
    else {
    	if(p) printf("%d\n", dispatchExpression(e, p));
    }
    
    int i;
    for(i=0; i < a->data.printStmt.endl; i++) printf("\n");
}


static void execStmt(struct ExecEnviron* e, struct AstElement* a) {
    assert(a);
    assert(ekStatements == a->kind);
    int i;
    for(i=0; i<a->data.statements.count; i++) {
        dispatchStatement(e, a->data.statements.statements[i]);
    }
}


void execAst(struct ExecEnviron* e, struct AstElement* a) {
    dispatchStatement(e, a);
}

struct ExecEnviron* createEnv() {
    assert(ekLastElement == (sizeof(valExecs)/sizeof(*valExecs)));
    assert(ekLastElement == (sizeof(runExecs)/sizeof(*runExecs)));
    return calloc(1, sizeof(struct ExecEnviron));
}

void freeEnv(struct ExecEnviron* e) {
    free(e);
}



%}

%union {
    int val;
    char op;
    char* name;
    struct AstElement* ast;  /* this is to store AST elements */
}

%token TOKEN_BEGIN TOKEN_END TOKEN_WHILE TOKEN_IF TOKEN_ELSE TOKEN_DO TOKEN_FOR TOKEN_SWITCH TOKEN_CASE TOKEN_BREAK TOKEN_DEFAULT TOKEN_PRINT TOKEN_NEWLINE TOKEN_EOF TOKEN_ENDLINE
%token<name> TOKEN_ID TOKEN_STRING
%token<val> TOKEN_NUMBER
%token<op> TOKEN_OPERATOR TOKEN_UNARY_OPERATOR
%type<val> endline ignoreNL
%type<ast> program block statements statement assignment expression forStmt whileStmt dowhileStmt ifStmt elseifStmt elseStmt switchStmt caseStmt defaultStmt call printStmt
%start program

%{

void yyerror(struct AstElement **astDest, const char* const message);

%}

%%

program: statements { (*(struct AstElement**)astDest) = $1; };

block: TOKEN_BEGIN statements TOKEN_END{ $$ = $2; };

statements: {$$=0;}
    | statements statement TOKEN_NEWLINE {$$=makeStatement($1, $2);}
    | statements block {$$=makeStatement($1, $2);}
    | statements TOKEN_NEWLINE {$$=$1;}
    ;

statement:
      assignment {$$=$1;}
    | forStmt {$$=$1;}
    | whileStmt {$$=$1;}
    | dowhileStmt {$$=$1;}
    | ifStmt {$$=$1;}
    | switchStmt {$$=$1;}
    | block {$$=$1;}
    | printStmt {$$=$1;}
    ;

assignment: TOKEN_ID '=' expression {$$=makeAssignment($1, $3);};

expression: expression TOKEN_OPERATOR expression {$$=makeExp($1, $3, $2);}
    | TOKEN_ID TOKEN_UNARY_OPERATOR {$$=makePostfixUnaryOp($1, $2);}
    | TOKEN_UNARY_OPERATOR TOKEN_ID {$$=makePrefixUnaryOp($2, $1);}
    | TOKEN_NUMBER {$$=makeExpByNum($1);}
    | TOKEN_ID {$$=makeExpByName($1);}
    | call {$$=$1;}
    ;

whileStmt: TOKEN_WHILE expression TOKEN_DO statements TOKEN_END{$$=makeWhile($2, $4);};

dowhileStmt: TOKEN_DO statements TOKEN_WHILE expression{$$=makeDoWhile($4, $2);};

ifStmt: TOKEN_IF expression TOKEN_DO statements elseifStmt elseStmt TOKEN_END{$$=makeIf($2, $4, $5, $6);};

elseifStmt: {$$=0;}
		| elseifStmt TOKEN_ELSE TOKEN_IF expression TOKEN_DO statements{$$=makeElseIf($1, $4, $6);};
		
elseStmt: {$$=0;}
		| TOKEN_ELSE TOKEN_DO statements	{$$=makeElse($3);};

switchStmt: TOKEN_SWITCH expression ignoreNL caseStmt defaultStmt TOKEN_END {$$=makeSwitch($2, $4, $5);};

caseStmt: {$$=0;}
		| caseStmt TOKEN_CASE expression statements TOKEN_BREAK ignoreNL {$$=makeCase($1, $3, $4, 1);}
		| caseStmt TOKEN_CASE expression statements {$$=makeCase($1, $3, $4, 0);};

defaultStmt: {$$=0;}
		| TOKEN_DEFAULT statements {$$=makeDefault($2);};

ignoreNL: {$$=0;}
		| ignoreNL TOKEN_NEWLINE {$$=0;};

forStmt: TOKEN_FOR statement ';' expression ';' statement TOKEN_DO statements TOKEN_END {$$=makeFor($2, $4, $6, $8);};

call: TOKEN_ID '(' expression  ')' {$$=makeCall($1, $3);};

printStmt: TOKEN_PRINT endline {$$=makePrint(0, 0, $2);}
		| TOKEN_PRINT TOKEN_STRING endline {$$=makePrint($2, 0, $3);}
		| TOKEN_PRINT TOKEN_STRING expression endline {$$=makePrint($2, $3, $4);}
		| TOKEN_PRINT expression {$$=makePrint(0, $2, 0);};
		
endline: {$$=0;}
		| endline TOKEN_ENDLINE {$$=$1+1;};
		

%%



void yyerror(struct AstElement **astDest, const char* const message) {
    fprintf(stderr, "Parse error:%s\n", message);
    exit(1);
}

int main(int argc, char **argv) {
		if(argc != 2) {
			printf("Wrong Argument. Only file name accepted\n");
			return 1;
		}
		freopen(argv[1], "r", stdin);
		
    yydebug = 0;
    struct AstElement *a = 0;
    yyparse(&a);
    
    assert(a);
    struct ExecEnviron* e = createEnv();
    execAst(e, a);
    freeEnv(e);
    /* TODO: destroy the AST */
}


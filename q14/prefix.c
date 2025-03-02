#include <stdio.h>
#include <string.h>
#include <ctype.h>

int prec(char op) {
    if (op == '*' || op == '/') return 2;
    if (op == '+' || op == '-') return 1;
    return 0;
}

void infixToPostfix(char* infix) {
    int len = strlen(infix);
    char result[len + 1];  // Output postfix infixression
    char stack[len];       // Operator stack
    int j = 0, top = -1;   // `j` for result index, `top` for stack

    for (int i = 0; i < len; i++) {
        char c = infix[i];

        // If operand (a-z or 0-9), add to result
        if (isalnum(c)) {
            result[j++] = c;
        }
        // If operator, process precedence
        else {
            while (top != -1 && prec(stack[top]) >= prec(c)) {
                result[j++] = stack[top--];  // Pop stack to result
            }
            stack[++top] = c;  // Push current operator
        }
    }

    // Pop remaining operators from stack
    while (top != -1) {
        result[j++] = stack[top--];
    }

    result[j] = '\0';  // Null terminate result
    printf("%s\n", result);
}

int main() {
    char infix[] = "a+b*c-d/e";  // Example input
    infixToPostfix(infix);       // Convert and print postfix
    return 0;
}
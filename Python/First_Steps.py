#Greeting function

def greeting():
    first_name = input("Please write your First name: ")
    last_name = input("Please write your Last name: ")
    full_name = first_name.strip() + " " + last_name.strip()
    print("Hello, Dear " + full_name.title() + " " + "how are you today?")
    
greeting()

#First try at a weird calculator program

# Creating a calculation for "+","-","*","/" and "pow"

#function to start the calculator

def start():
    choice = input("Choose the type of calculation do you wish to do? (addition, subtraction, multiplication, division, power) ")
    if choice.lower().strip() == "addition":
        return adittion()
    elif choice.lower().strip() == "subtraction":
        return subtraction()
    elif choice.lower().strip() == "multiplication":
        return multiplication()
    elif choice.lower().strip() == "division":
        return division()
    elif choice.lower().strip() == "power":
        return power()
    else:
        print("Invalid choice, please try again")
        start()

#addition function

def adittion():
    x = float(input("Choose the value of x:"))
    y = float(input("Choose the value of y:"))
    print(x + y)
    
#subtraction function

def subtraction():
    x = float(input("Choose the value of x:"))
    y = float(input("Choose the value of y:"))
    print(x - y)
    
#multiplication function
    
def multiplication():
    x = float(input("Choose the value of x:"))
    y = float(input("Choose the value of y:"))
    print(x * y)
    
#division function
    
def division():
    x = float(input("Choose the value of x:"))
    y = float(input("Choose the value of y:"))
    print(x / y)

#power function
    
def power():
    x = int(input("Choose the value of x:"))
    y = int(input("Choose the value of y:"))
    print(pow(x,y))
    
start()

# Building a Chess board as a 2D list
board = [
    ["-", "-", "-", "-", "-", "-", "-", "-"],  
    ["-", "-", "-", "-", "-", "-", "-", "-"],  
    ["-", "-", "-", "-", "-", "-", "-", "-"],  
    ["-", "-", "-", "-", "-", "-", "-", "-"],  
    ["-", "-", "-", "-", "-", "-", "-", "-"],  
    ["-", "-", "-", "-", "-", "-", "-", "-"],  
    ["-", "-", "-", "-", "-", "-", "-", "-"],  
    ["-", "-", "-", "-", "-", "-", "-", "-"],  
]
# Convert chess notation to row and column indices
def convert_position(chess_notation):
    columns = 'ABCDEFGH'
    
      # Checking if input is exactly two characters long
    if len(chess_notation) != 2:
        print("Input error: Invalid notation length. Please enter a position like 'E1' or 'A8'.")
        return None
    
    # Checking if the first character is a valid column and the second is a valid row
    if chess_notation[0].upper() not in columns or not chess_notation[1].isdigit():
        print("Input error: Invalid notation format. Please use a letter (A-H) followed by a number (1-8), like 'E1' or 'A8'.")
        return None
    
    # Converting row and column to indices, and validate the row range
    row = 8 - int(chess_notation[1])
    col = columns.index(chess_notation[0].upper())
    
    if row < 0 or row > 7:
        print("Input error: Row out of range. Please enter a row between 1 and 8.")
        return None
    
    return row, col
# Convert row and column indices back to chess notation
def convert_to_notation(row, col):
    columns = 'ABCDEFGH'
    return f"{columns[col]}{8 - row}"

# Display the chess board
def display_board(board):
    print("   -----------------")
    for i, row in enumerate(board):
        print(8 - i, "|", " ".join(row), "|")
    print("   -----------------")
    print("    A B C D E F G H")

# Get moves for King or Rook
def get_moves(piece, row, col):
    moves = []
    if piece == "K":  # King moves one square in any direction
        directions = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)]
        moves = [(row + dr, col + dc) for dr, dc in directions if 0 <= row + dr < 8 and 0 <= col + dc < 8]
    elif piece == "R":  # Rook moves horizontally and vertically
        moves = [(row, i) for i in range(8) if i != col] + [(i, col) for i in range(8) if i != row]
    return moves

# Place either the King or the Rook
def place_white_piece():
    # Prompt the user to select either the King or the Rook
    while True:
        choice = input("Do you want to place the King or the Rook? (Enter 'K' for King or 'R' for Rook): ").upper()
        
        if choice == "K":
            piece = "K"
            break
        elif choice == "R":
            piece = "R"
            break
        else:
            print("Invalid choice. Please enter 'K' for King or 'R' for Rook.")

    # Place the chosen piece on the board
    while True:
        position = input(f"Enter the position for the {piece} (e.g., E1): ").upper()
        pos = convert_position(position)
        
        # Ensure the position is valid and empty
        if pos and board[pos[0]][pos[1]] == "-":
            board[pos[0]][pos[1]] = piece  # Place the selected piece
            display_board(board)
            print("You've chosen the position successfully!")
            return piece, pos  # Return the piece type and position
        else:
            print("Position error. Choose another position.")

# Place black pieces with a count check
def place_black_pieces():
    black_pieces_count = 0  # Track number of black pieces placed
    piece_limits = {"p": 8, "r": 2, "n": 2, "b": 2, "q": 1, "k": 1}  # Limits per piece type
    placed_black_pieces_count = {"p": 0, "r": 0, "n": 0, "b": 0, "q": 0, "k": 0}  # Count of each type placed
    
    while black_pieces_count < 16:
        input_str = input("Place a black piece or type 'done' to finish (e.g., p A7 or done): ").lower()
        
        if input_str == "done":
            if black_pieces_count < 1:
                print("At least 1 black piece must be placed.")
                continue
            break

        try:
            piece, position = input_str.split()
            if piece not in piece_limits:
                print("Input error: Invalid piece type. Use 'p', 'r', 'n', 'b', 'q', or 'k'.")
                continue
            
            if placed_black_pieces_count[piece] >= piece_limits[piece]:
                print(f"Limit reached for piece '{piece}'. You can't place more.")
                continue
            # Ensuring a valid empty position
            pos = convert_position(position)
            if pos and board[pos[0]][pos[1]] == "-": 
                board[pos[0]][pos[1]] = piece # Placing the selected piece
                black_pieces_count += 1 # Counting the pieces to check if there's more than 1 or less than 16
                placed_black_pieces_count[piece] += 1 # Checking the count by type
                print("You've chosen a piece successfully!")
                display_board(board)
            else:
                print("Position error. Choose another position.")
        except ValueError:
            print("Input error: Use format '<piece> <position>' (e.g., 'p a7').")

# Check captures by white piece
def check_captures(piece, piece_pos):
    captures = []
    possible_moves = get_moves(piece, piece_pos[0], piece_pos[1])
    for r, c in possible_moves:
        if board[r][c] in ["p", "r", "n", "b", "q", "k"]:
            captures.append((piece, convert_to_notation(piece_pos[0], piece_pos[1]), board[r][c], convert_to_notation(r, c)))
    return captures

# Main game loop
def game_loop():
    display_board(board)
    white_piece, piece_pos = place_white_piece()
    place_black_pieces()
    captures = check_captures(white_piece, piece_pos)

    if captures:
        print("White piece can take the following black pieces:")
        for capture in captures:
            white_piece, white_pos, black_piece, black_pos = capture
            print(f"{white_piece} at {white_pos} can take {black_piece} at {black_pos}")
    else:
        print("No black pieces can be taken by the white piece.")

# Starting the game loop
game_loop()

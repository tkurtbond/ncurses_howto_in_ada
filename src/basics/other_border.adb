with Terminal_Interface.Curses;         use Terminal_Interface.Curses;
with Terminal_Interface.Curses_Constants;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Terminal_Interface.Curses.Text_IO.Integer_IO;

procedure Other_Border is
   package Integer_IO is new Terminal_Interface.Curses.Text_IO.Integer_IO
     (Integer);
   package CC renames Terminal_Interface.Curses_Constants;

   Debug : constant Boolean := False;

   type Box_Action_Type is (Draw_Box, Erase_Box);

   use Integer_IO;
   -- Rather than instantiate a new package for both Line_Position
   -- and Column_Position, just instantiate one for Integer and do an
   -- explicit cast to Integer for output.

   type Window_Border_Type is record
      Left_Side, Right_Side, Top_Side, Bottom_side   : Attributed_Character;
      Top_Left, Top_Right, Bottom_Left, Bottom_Right : Attributed_Character;
      Blank                                          : Attributed_Character;
   end record;

   type Window_Parameters_Type is record
      Start_Y : Line_Position;
      Start_X : Column_Position;
      Height  : Line_Position;
      Width   : Column_Position;
      Border  : Window_Border_Type;
   end record;

   procedure Create_Attributed_Character
     (Ch : Character; A_Ch : out Attributed_Character)
   is
   begin
      A_Ch := (Ch => Ch, Color => 0, Attr => (others => False));
   end Create_Attributed_Character;

   procedure Init_Window_Parameters (WP : out Window_Parameters_Type) is
   begin
      WP.Height  := 3;
      WP.Width   := 10;
      WP.Start_Y := (Lines - WP.Height) / 2;
      WP.Start_X := (Columns - WP.Width) / 2;
      Create_Attributed_Character ('|', WP.Border.Left_Side);
      Create_Attributed_Character ('|', WP.Border.Right_Side);
      Create_Attributed_Character ('-', WP.Border.Top_Side);
      Create_Attributed_Character ('-', WP.Border.Bottom_Side);
      Create_Attributed_Character ('+', WP.Border.Top_Left);
      Create_Attributed_Character ('+', WP.Border.Top_Right);
      Create_Attributed_Character ('+', WP.Border.Bottom_Left);
      Create_Attributed_Character ('+', WP.Border.Bottom_Right);
      Create_Attributed_Character (' ', WP.Border.Blank);
   end Init_Window_Parameters;

   procedure Print_Window_Parameters (WP : in Window_Parameters_Type) is
      W : Window := Standard_Window;
   begin
      Move_Cursor (W, 25, 0);
      Put (Integer (WP.Start_X), 0);
      Put (' ');
      Put (Integer (WP.Start_Y), 0);
      Put (' ');
      Put (Integer (WP.Width), 0);
      Put (' ');
      Put (Integer (WP.Height), 0);
      Refresh;
   end Print_Window_Parameters;

   procedure Create_Box
     (WP : in Window_Parameters_Type; Action : in Box_Action_Type)
   is
      X, W : Column_Position;
      Y, H : Line_Position;
   begin
      X := WP.Start_X;
      Y := WP.Start_Y;
      W := WP.Width;
      H := WP.Height;

      case Action is
         when Draw_Box =>
            Add (Line => Y, Column => X, Ch => WP.Border.Top_Left);
            Add (Line => Y, Column => X + W, Ch => WP.Border.Top_Right);
            Add (Line => Y + H, Column => X, Ch => WP.Border.Bottom_Left);
            Add (Line => Y + H, Column => X + W, Ch => WP.Border.Bottom_Right);
            -- X is a Column_Position, and Y is a Line_Position, but
            --  the Line_Size parameter to Horizontal_Line and
            --  Vertical_Line are both a Natural, so we need to
            --  explictly convert to Natural when passing those
            --  parameters.
            Move_Cursor (Line => Y, Column => X + 1);
            Horizontal_Line
              (Line_Size   => Natural (W - 1),
               Line_Symbol => WP.Border.Top_Side);
            Move_Cursor (Line => Y + H, Column => X + 1);
            Horizontal_Line
              (Line_Size   => Natural (W - 1),
               Line_Symbol => WP.Border.Bottom_Side);
            Move_Cursor (Line => Y + 1, Column => X);
            Vertical_Line
              (Line_Size   => Natural (H - 1),
               Line_Symbol => WP.Border.Left_Side);
            Move_Cursor (Line => Y + 1, Column => X + W);
            Vertical_Line
              (Line_Size   => Natural (H - 1),
               Line_Symbol => WP.Border.Right_Side);
         when Erase_Box =>
            for J in Y .. Y + H loop
               for I in X .. X + W loop
                  Add (Line => J, Column => I, Ch => WP.Border.Blank);
               end loop;
            end loop;
      end case;
   end Create_Box;

   Window_Parameters : Window_Parameters_Type;
   Key               : Real_Key_Code;
   Cyan_On_Black     : constant Color_Pair := 1;

   Start_X : Column_Position renames Window_Parameters.Start_X;
   Start_Y : Line_Position renames Window_Parameters.Start_Y;
begin
   Init_Screen;                          -- Start curses mode.
   Start_Color;                          -- Start the color functionality.
   Set_CBreak_Mode (True); 
   -- Line buffering disabled, pass on everything to me.
   Set_Keypad_Mode (SwitchOn => True);   -- I need that nifty F1.
   Set_Echo_Mode (False);                -- Don't show what is typed.
   Init_Pair (Cyan_On_Black, CC.COLOR_CYAN, CC.COLOR_BLACK);

   Init_Window_Parameters (Window_Parameters);
   if Debug then
      Print_Window_Parameters (Window_Parameters);
   end if;
   Set_Character_Attributes (Color => Cyan_On_Black);
   Put ("Press F1 to exit");
   Refresh;
   Set_Character_Attributes;            -- Defaults to normal video and color pair 0.

   Create_Box (Window_Parameters, Draw_Box);
   loop
      Key := Get_Keystroke;
      exit when Key = Key_F1;
      case Key is
         when Key_LEFT =>
            Create_Box (Window_Parameters, Erase_Box);
            Start_X := Start_X - 1;
            Create_Box (Window_Parameters, Draw_Box);
         when Key_RIGHT =>
            Create_Box (Window_Parameters, Erase_Box);
            Start_X := Start_X + 1;
            Create_Box (Window_Parameters, Draw_Box);
         when Key_UP =>
            Create_Box (Window_Parameters, Erase_Box);
            Start_Y := Start_Y - 1;
            Create_Box (Window_Parameters, Draw_Box);
         when Key_DOWN =>
            Create_Box (Window_Parameters, Erase_Box);
            Start_Y := Start_Y + 1;
            Create_Box (Window_Parameters, Draw_Box);
         when others =>
            null;
      end case;
   end loop;
   End_Screen;                          -- End curses mode.
end Other_Border;

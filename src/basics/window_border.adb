with Terminal_Interface.Curses; use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;

procedure Window_Border is 
   
   function Create_New_Window (Height : Line_Count; 
                               Width : Column_Count;
                               Start_Y : Line_Position; 
                               Start_X : Column_Position) 
                              return Window is 
      Local_Window : Window := Create (Height, Width, Start_Y, Start_X);
   begin
      Box (Local_Window);               -- Use the default characters for the
                                        -- vertical and horizontal lines.
      Refresh (Local_Window);           -- Show that box.
      return Local_Window;
   end Create_New_Window;
   
   procedure Destroy_Window (Win : in out Window) is
      Kill : constant Attributed_Character 
        := (Ch => ' ', Color => 0, Attr => (others => False));
      -- Set up a blank character to kill the lines around the box.
   begin
      -- Box (Win, Kill, Kill);
      -- Unfortunately, this would leave the corners of the box behind
      -- without clearing them.  So we do the following instead.
      Border (Win, Kill, Kill, Kill, Kill, Kill, Kill, Kill, Kill);
      -- The paramaters are:
      -- 1. Win: the window on which to operate
      -- 2. Left_Side_Symbol: character to be used for the left side of the window          
      -- 3. Right_Side_Symbol: character to be used for the right side of the window         
      -- 4. Top_Side_Symbol: character to be used for the top side of the window           
      -- 5. Bottom_Side_Symbol: character to be used for the bottom side of the window        
      -- 6. Upper_Left_Corner_Symbol: character to be used for the top left corner of the window    
      -- 7. Upper_Right_Corner_Symbol: character to be used for the top right corner of the window   
      -- 8. Lower_Left_Corner_Symbol: character to be used for the bottom left corner of the window 
      -- 9. Lower_Right_Corner_Symbol: character to be used for the bottom right corner of the window
      Refresh (Win);
      Delete (Win);
   end Destroy_Window;

   Height : constant := 3;
   Width : constant := 10;
   Start_Y : Line_Position;
   Start_X : Column_Position;
   Key : Real_Key_Code;
   My_Window : Window;
begin
   Init_Screen;                   -- Start curses mode. 
   Set_Cbreak_Mode (True);        -- Disable line buffering. Pass on 
                                  -- everything to me.
   Set_Keypad_Mode;               -- I need that nifty F1.
   
   -- Note that here Lines and Columns are functions that return the current 
   -- lines and columns of the screen.
   Start_Y := (Lines - Height) / 2;      -- Calculating for a center placement
   Start_X := (Columns - Width) / 2;     -- of the window.
   Put ("Press F1 to exit");
   Refresh;
   My_Window := Create_New_Window (Height, Width, Start_Y, Start_X);
   
   loop
      Key := Get_Keystroke;
      exit when Key = Key_F1;
      case Key is 
         when Key_LEFT => 
            Destroy_Window (My_Window);
            Start_X := Start_X - 1;
            My_Window := Create_New_Window (Height, Width, Start_Y, Start_X);
         when Key_RIGHT =>
            Destroy_Window (My_Window);
            Start_X := Start_X + 1;
            My_Window := Create_New_Window (Height, Width, Start_Y, Start_X);
         when Key_UP =>
            Destroy_Window (My_Window);
            Start_Y := Start_Y - 1;
            My_Window := Create_New_Window (Height, Width, Start_Y, Start_X);
         when Key_DOWN =>
            Destroy_Window (My_Window);
            Start_Y := Start_Y + 1;
            My_Window := Create_New_Window (Height, Width, Start_Y, Start_X);
         when others => null;
      end case;
   end loop;
   
   End_Screen;                          -- End curses mode.
end Window_Border;

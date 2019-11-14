LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_signed.all;
USE ieee.std_logic_arith.all;
--USE ieee.numeric_std.all;

entity public_encryption is
  Port ( 
    original : in std_logic_vector(7 downto 0);
    encrypted : out std_logic_vector(7 downto 0);
    i:in integer;
    public_key : in std_logic_vector(7 downto 0) :="00000000";
    mode : in std_logic_vector(1 downto 0)
    );
end public_encryption;

architecture Behavioral of public_encryption is
signal a: integer;
signal b: integer;
signal cantor : integer;
signal key:std_logic_vector(7 downto 0):="00000000";
begin

a <=conv_integer(unsigned(public_key(3 downto 0)));
b <=conv_integer(unsigned(public_key(7 downto 4) xor "1010"));

-- Cantor Pairing Function 
cantor <= 5*(a+b)*(a+b+1)+b;
key <= 
conv_std_logic_vector((5*(cantor+i)*(cantor+i+1))+i,8) when mode="11" else
"10010011" when mode="00"
else "00000000";

encrypted<=original xor key;

end Behavioral;
                                                                                                                                            
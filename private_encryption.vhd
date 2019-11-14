LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_signed.all;
USE ieee.std_logic_arith.all;
--USE ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity private_encryption is
Port ( 
    original : in std_logic_vector(7 downto 0);
    encrypted : out std_logic_vector(7 downto 0)
    );
end private_encryption;

architecture Behavioral of private_encryption is

begin
encrypted <= original xor "10010011";

end Behavioral;

B:��!  � ��C�.:��! � ��D�.�	�  � :��2��x	�  � �MAIN-ROM slot patch v1.00
Copyright (C)2020 HRA!

$Detect MSX1.
Copy [FCC1h] --> [FFF7h]
$Detect MSX2 or later.
No operation.
$
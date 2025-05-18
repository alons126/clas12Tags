# use strict;
use warnings;

use lib ("../");
use clas12_configuration_string;

use Math::Trig;

our %configuration;
our %parameters;

our $target_zpos;
my $target_length = 256.56;

# RGM_lAr implementation
sub build_new_rgm_targets {
    my ($configuration_string) = @_; #To add $configuration_string as an argument to the build_new_rgm_targets subroutine

    # Flag Shaft Geometry (cm/deg)
    my @flag_shaft = (0.2665, 0.3175, 8.145, 0, 360, 0, 0, 0); #Inner radius, outer radius, half length, initial angle, final angle, x angle, y angle, z angle

    my (@Sn_flag_pole, @C_flag_pole, @Sn_flag, @C_flag, @Sn_target, @C_target, @flag_pole_relpos, @row);
    my ($separation, $offset_x, $offset_y, $offset_z, $row_pole, $row_target, $row_flag, $Sn_p_x, $Sn_p_y);
    my ($C_p_x, $C_p_y, $Sn_t_x, $Sn_t_y, $C_t_x, $C_t_y, $Sn_f_x, $Sn_f_y, $C_f_x, $C_f_y);

    # eparation = distance the flags set the target above the end of the flag poles.
    # This distance is kept the same for small and large foils.
    $separation = 0.127;

    @flag_pole_relpos = (0.381, 1.25, 1.25, 1.25); #Distance from end of flag_shaft to center of flag_pole 1, center of flag_pole 1 to center of flag_pole 2, center of flag_pole 2 to center of flag_pole 3, and center of flag_pole 3 to center of flag_pole 4
    @row = ($flag_shaft[2] - $flag_pole_relpos[0] - $flag_pole_relpos[1] - $flag_pole_relpos[2] - $flag_pole_relpos[3], $flag_shaft[2] - $flag_pole_relpos[0] - $flag_pole_relpos[1] - $flag_pole_relpos[2], $flag_shaft[2] - $flag_pole_relpos[0] - $flag_pole_relpos[1], $flag_shaft[2] - $flag_pole_relpos[0]); #Positions of rows of the flag_poles.

    # In the following, we set the parameters for the foil target setup based on the blueprints of the system.
    # Here:
    #       - Small foils: the same dimensions as the previous implementation (RGM_2_C)
    #       - Large foils: dimensions are from the blueprints of the system, with the exception of the effective width. 
    #                      The effective width is the width that a rectangular box would need to have—given the same thickness and height as the actual foil target—so that its total volume equals that of the irregularly shaped (octagonal) foil.

    if ($configuration_string eq "rgm_fall2021_C_v2_S" or $configuration_string eq "rgm_fall2021_C_v2_L")
    {
        # Here we set the parameters for the foil target setup based on the rgm_fall2021_C (RGM_2_C) variation and the blueprints of the system.
        # Small foils (rgm_fall2021_C_v2_S): the same dimensions as the previous implementation (RGM_2_C)
        # Large foils (rgm_fall2021_C_v2_L): dimensions are from the blueprints of the system, with the exception of the effective width.

        # Flag Pole Geometry (cm/deg)
        @Sn_flag_pole = (0.084, 0.1195, 1.0605, 0, 360, 90, 55, 0); #Inner radius, outer radius, half length (outside of flag_shaft to end of flag_pole), initial angle, final angle, x angle, y angle, z angle for the Sn flag poles.
        @C_flag_pole = (0.084, 0.1195, 1.0605, 0, 360, 90, 0, 0);   #Inner radius, outer radius, half length (outside of flag_shaft to end of flag_pole), initial angle, final angle, x angle, y angle, z angle for the C flag poles.

        if ($configuration_string eq "rgm_fall2021_C_v2_S") {
            # Flag Geometry (cm)
            # Half x = width -> same as sketch (0.334/2 cm)
            # Half y = hight -> same as sketch ((0.127+0.254)/2=0.381/2 cm)
            # Half z = thickness -> same as sketch (0.071/2 cm)
            @Sn_flag = (0.167, 0.1905, 0.0355, 0, 0, -55); #Half x, y, z dimensions and x, y, z angles for the Sn flag that holds the target foils.
            @C_flag = (0.167, 0.1905, 0.0355, 0, 0, 0);    #Half x, y, z dimensions and x, y, z angles for the C flag that holds the target foils.

            # Targets Geometry (cm)
            # Half y = hight -> same as sketch (0.405 cm)
            # Half z = thickness -> same as analysis note (0.1 cm)
            @Sn_target = (0.1685, 0.405, 0.1, 0, 0, -55); #Half x, y, z dimensions and x, y, z angles for the Sn target foils. I did a lot of geometry to try and keep the thickness & over all volume the same as in the CAD file.
            @C_target = (0.1685, 0.405, 0.1, 0, 0, 0);    #Half x, y, z dimensions and x, y, z angles for the C target foils. I did a lot of geometry to try and keep the thickness & over all volume the same as in the CAD file.
        } elsif ($configuration_string eq "rgm_fall2021_C_v2_L") {
            # Flag Geometry (cm)
            # Half x = width -> same as sketch (0.334/2 cm)
            # Half y = hight -> same as sketch ((0.127+0.254)/2=0.381/2 cm)
            # Half z = thickness -> same as sketch (0.071/2 cm)
            @Sn_flag = (0.167, 0.1905, 0.0355, 0, 0, -55); #Half x, y, z dimensions and x, y, z angles for the Sn flag that holds the target foils.
            @C_flag = (0.167, 0.1905, 0.0355, 0, 0, 0);    #Half x, y, z dimensions and x, y, z angles for the C flag that holds the target foils.

            # Targets Geometry (cm)
            # Half y = hight -> same as sketch (0.455 cm)
            # Half z = thickness -> same as analysis note (0.1 cm)
            @Sn_target = (0.243912, 0.455, 0.1, 0, 0, -55); #Half x, y, z dimensions and x, y, z angles for the Sn target foils. I did a lot of geometry to try and keep the thickness & over all volume the same as in the CAD file.
            @C_target = (0.243912, 0.455, 0.1, 0, 0, 0);    #Half x, y, z dimensions and x, y, z angles for the C target foils. I did a lot of geometry to try and keep the thickness & over all volume the same as in the CAD file.
        }

        # Offset to "zero" the center of the target.
        $offset_x = 0.0;
        $offset_y = -(2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation); # Set Y=0 to be center on target.
        $offset_z = (0.625 - (($row[1] - $Sn_flag_pole[1] + 2 * $Sn_flag[2] + $Sn_target[2]) + ($row[2] - $Sn_flag_pole[1] + 2 * $Sn_flag[2] + $Sn_target[2])) / 2); #0.625 from magic? (first flag is flag 0)

        # Adjusted position of the rows for the flag poles.
        $row_pole = ($row[3] + $offset_z);

        # Adjusted positions of the rows for the target foils.
        $row_target = ($row[3] + $offset_z - $Sn_flag_pole[1] + 2 * $Sn_flag[2] + $Sn_target[2]);

        # Adjusted positions of the rows for the flags.
        $row_flag = ($row[3] + $offset_z - $Sn_flag_pole[1] + $Sn_flag[2]);

        # Sn Flag Pole position (cm).
        $Sn_p_x = -(0.81915 * ($Sn_flag_pole[2] + $flag_shaft[1]) + $offset_x); # Cos(35) is the decimal out front.
        $Sn_p_y = 0.57358 * ($Sn_flag_pole[2] + $flag_shaft[1]) + $offset_y;   # Sin(35) is the decimal out front.

        # C Flag Pole positions (cm).
        $C_p_x = 0.0 + $offset_x;
        $C_p_y = $C_flag_pole[2] + $flag_shaft[1] + $offset_y;

        # Sn Targets positions (cm).
        $Sn_t_x = -(0.81915 * (2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation) + $offset_x); # Cos(35) is the decimal out front.
        $Sn_t_y = 0.57358 * (2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation) + $offset_y;    # Sin(35) is the decimal out front.

        # C Targets positions (cm).
        $C_t_x = 0.0 + $offset_x;
        $C_t_y = (2 * $C_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation) + $offset_y;

        # Sn Flag positions (cm).
        $Sn_f_x = -(0.81915 * (2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_flag[1]) + $offset_x); # Cos(35) is the decimal out front.
        $Sn_f_y = 0.57358 * (2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_flag[1]) + $offset_y;    # Sin(35) is the decimal out front.

        # C Flag positions (cm).
        $C_f_x = 0.0 + $offset_x;
        $C_f_y = (2 * $C_flag_pole[2] + $flag_shaft[1] + $Sn_flag[1]) + $offset_y;

    } elsif ($configuration_string eq "rgm_fall2021_Ar") {
        # Here we set the parameters for the lAr target setup.
        # This time, the Sn and C foils are rotated to -30 deg and +30 deg, respectively.

        # Flag Pole Geometry (cm/deg)
        @Sn_flag_pole = (0.084, 0.1195, 1.0605, 0, 360, 90, 30, 0); #Inner radius, outer radius, half length (outside of flag_shaft to end of flag_pole), initial angle, final angle, x angle, y angle, z angle for the Sn flag poles.
        @C_flag_pole = (0.084, 0.1195, 1.0605, 0, 360, 90, -30, 0);   #Inner radius, outer radius, half length (outside of flag_shaft to end of flag_pole), initial angle, final angle, x angle, y angle, z angle for the C flag poles.

        # Flag Geometry (cm)
        @Sn_flag = (0.167, 0.1905, 0.0355, 0, 0, -30); #Half x, y, z dimensions and x, y, z angles for the Sn flag that holds the target foils.
        @C_flag = (0.167, 0.1905, 0.0355, 0, 0, 30);    #Half x, y, z dimensions and x, y, z angles for the C flag that holds the target foils.

        # Targets Geometry (cm)
        @Sn_target = (0.1685, 0.405, 0.1, 0, 0, -30); #Half x, y, z dimensions and x, y, z angles for the Sn target foils. I did a lot of geometry to try and keep the thickness & over all volume the same as in the CAD file.
        @C_target = (0.1685, 0.405, 0.1, 0, 0, 30);    #Half x, y, z dimensions and x, y, z angles for the C target foils. I did a lot of geometry to try and keep the thickness & over all volume the same as in the CAD file.

        my $Sn_rot_degrees = $Sn_target[5];
        my $C_rot_degrees = $C_target[5];

        my $Sn_rot_radians = deg2rad($Sn_rot_degrees); # Convert to radians
        my $C_rot_radians = deg2rad($C_rot_degrees);   # Convert to radians

        # Offset to "zero" the center of the target.
        $offset_x = 0.0;
        $offset_y = -(2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation); # Set Y=0 to be center on target.
        $offset_z = (0.625 - (($row[1] - $Sn_flag_pole[1] + 2 * $Sn_flag[2] + $Sn_target[2]) + ($row[2] - $Sn_flag_pole[1] + 2 * $Sn_flag[2] + $Sn_target[2])) / 2); #0.625 from magic? (first flag is flag 0)

        # Adjusted position of the rows for the flag poles.
        $row_pole = ($row[3] + $offset_z);

        # Adjusted positions of the rows for the target foils.
        $row_target = ($row[3] + $offset_z - $Sn_flag_pole[1] + 2 * $Sn_flag[2] + $Sn_target[2]);

        # Adjusted positions of the rows for the flags.
        $row_flag = ($row[3] + $offset_z - $Sn_flag_pole[1] + $Sn_flag[2]);

        # Sn Flag Pole position (cm).
        $Sn_p_x = sin($Sn_rot_radians) * ($Sn_flag_pole[2] + $flag_shaft[1]) + $offset_x;  # Sin(-30) is the decimal out front.
        $Sn_p_y = cos($Sn_rot_radians) * ($Sn_flag_pole[2] + $flag_shaft[1]) + $offset_y; # Cos(-30) is the decimal out front.
        # $Sn_p_x = -(0.689 + $offset_x); # 0.689 for rotation by 30deg
        # $Sn_p_y = -0.184652 + $C_flag_pole[2] + $flag_shaft[1] + $offset_y; # -0.184652 for rotation by 30deg

        # C Flag Pole positions (cm).
        $C_p_x = sin($C_rot_radians) * ($C_flag_pole[2] + $flag_shaft[1]) + $offset_x; # Sin(30) is the decimal out front.
        $C_p_y = cos($C_rot_radians) * ($C_flag_pole[2] + $flag_shaft[1]) + $offset_y; # Cos(30) is the decimal out front.
        # $C_p_x = 0.689 + $offset_x; # 0.689 for rotation by 30deg
        # $C_p_y = -0.184652 + $C_flag_pole[2] + $flag_shaft[1] + $offset_y; # -0.184652 for rotation by 30deg

        # Sn Targets positions (cm).
        $Sn_t_x = sin($Sn_rot_radians) * (2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation) + $offset_x; # Sin(-30) is the decimal out front.
        $Sn_t_y = cos($Sn_rot_radians) * (2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation) + $offset_y; # Cos(-30) is the decimal out front.
        # $Sn_t_x = -(1.48525 + $offset_x);
        # $Sn_t_y = -0.398047 + (2 * $C_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation) + $offset_y;

        # C Targets positions (cm).
        $C_t_x = sin($C_rot_radians) * (2 * $C_flag_pole[2] + $flag_shaft[1] + $C_target[1] + $separation) + $offset_x; # Sin(30) is the decimal out front.
        $C_t_y = cos($C_rot_radians) * (2 * $C_flag_pole[2] + $flag_shaft[1] + $C_target[1] + $separation) + $offset_y; # Cos(30) is the decimal out front.
        # $C_t_x = 1.48525 + $offset_x;
        # $C_t_y = -0.398047 + (2 * $C_flag_pole[2] + $flag_shaft[1] + $Sn_target[1] + $separation) + $offset_y;

        # Sn Flag positions (cm).
        $Sn_f_x = sin($Sn_rot_radians) * (2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_flag[1]) + $offset_x; # Sin(-30) is the decimal out front.
        $Sn_f_y = cos($Sn_rot_radians) * (2 * $Sn_flag_pole[2] + $flag_shaft[1] + $Sn_flag[1]) + $offset_y; # Cos(-30) is the decimal out front.
        # $Sn_f_x = -(1.3145 + 0.0 + $offset_x);
        # $Sn_f_y = -0.352286 + (2 * $C_flag_pole[2] + $flag_shaft[1] + $Sn_flag[1]) + $offset_y;

        # C Flag positions (cm).
        $C_f_x = sin($C_rot_radians) * (2 * $C_flag_pole[2] + $flag_shaft[1] + $C_flag[1]) + $offset_x; # Sin(30) is the decimal out front.
        $C_f_y = cos($C_rot_radians) * (2 * $C_flag_pole[2] + $flag_shaft[1] + $C_flag[1]) + $offset_y; # Cos(30) is the decimal out front.
        # $C_f_x = 1.3145 + 0.0 + $offset_x;
        # $C_f_y = -0.352286 + (2 * $C_flag_pole[2] + $flag_shaft[1] + $Sn_flag[1]) + $offset_y;
    }

    # Mother Volume (parameters from RGM_2_C, RGM_2_Sn)
    my $nplanes = 4;
    my @oradius = (50.2, 50.2, 21.0, 21.0);
    my @z_plane = (-115.0, 265.0, 290.0, 300.0);

    # Vacuum target container
    my %detector = init_det();
    $detector{"name"} = "target";
    $detector{"mother"} = "root";
    $detector{"description"} = "Target Container";
    $detector{"color"} = "22ff22";
    $detector{"type"} = "Polycone";
    my $dimen = "0.0*deg 360*deg $nplanes*counts";
    for (my $i = 0; $i < $nplanes; $i++) {$dimen = $dimen . " 0.0*mm";}
    for (my $i = 0; $i < $nplanes; $i++) {$dimen = $dimen . " $oradius[$i]*mm";}
    for (my $i = 0; $i < $nplanes; $i++) {$dimen = $dimen . " $z_plane[$i]*mm";}
    $detector{"dimensions"} = $dimen;
    $detector{"material"} = "G4_Galactic";
    $detector{"style"} = 0;
    print_det(\%configuration, \%detector);

    # Flag Shaft
    $detector{"name"} = "flag shaft";
    $detector{"mother"} = "target";
    $detector{"description"} = "RGM Solid Target Tube Main";
    $detector{"pos"} = "$offset_x*cm $offset_y*cm $offset_z*cm";
    $detector{"rotation"} = "$flag_shaft[5]*deg $flag_shaft[6]*deg $flag_shaft[7]*deg";
    $detector{"color"} = "000099";
    $detector{"type"} = "Tube";
    $detector{"dimensions"} = "$flag_shaft[0]*cm $flag_shaft[1]*cm $flag_shaft[2]*cm 0*deg 360*deg";
    $detector{"material"} = "G4_Al"; #Al 6061-T6
    $detector{"style"} = 1;
    print_det(\%configuration, \%detector);

    # C flag pole
    $detector{"name"} = "Carbon_flag_pole";
    $detector{"mother"} = "target";
    $detector{"description"} = "RGM Solid Target Flag Pole C";
    $detector{"pos"} = "$C_p_x*cm $C_p_y*cm $row_pole*cm";
    $detector{"rotation"} = "$C_flag_pole[5]*deg $C_flag_pole[6]*deg $C_flag_pole[7]*deg";
    $detector{"color"} = "990000";
    $detector{"type"} = "Tube";
    $detector{"dimensions"} = "$C_flag_pole[0]*cm $C_flag_pole[1]*cm $C_flag_pole[2]*cm 0*deg 360*deg";
    $detector{"material"} = "G4_Al"; #Al 6061
    $detector{"style"} = 1;
    print_det(\%configuration, \%detector);

    # Tin flag pole
    $detector{"name"} = "Tin_flag_pole";
    $detector{"mother"} = "target";
    $detector{"description"} = "RGM Solid Target Flag Pole Sn";
    $detector{"pos"} = "$Sn_p_x*cm $Sn_p_y*cm $row_pole*cm";
    $detector{"rotation"} = "$Sn_flag_pole[5]*deg $Sn_flag_pole[6]*deg $Sn_flag_pole[7]*deg";
    $detector{"color"} = "990000";
    $detector{"type"} = "Tube";
    $detector{"dimensions"} = "$Sn_flag_pole[0]*cm $Sn_flag_pole[1]*cm $Sn_flag_pole[2]*cm 0*deg 360*deg";
    $detector{"material"} = "G4_Al"; #Al 6061
    $detector{"style"} = 1;
    print_det(\%configuration, \%detector);

    # Carbon Flag
    # C_flag = the piece that holds the target
    $detector{"name"} = "Carbon_flag";
    $detector{"mother"} = "target";
    $detector{"description"} = "RGM Solid Target Flag C";
    $detector{"pos"} = "$C_f_x*cm $C_f_y*cm $row_flag*cm";
    $detector{"rotation"} = "$C_flag[3]*deg $C_flag[4]*deg $C_flag[5]*deg";
    $detector{"color"} = "009900";
    $detector{"type"} = "Box";
    $detector{"dimensions"} = "$C_flag[0]*cm $C_flag[1]*cm $C_flag[2]*cm";
    $detector{"material"} = "G4_Al";
    $detector{"style"} = 1;
    print_det(\%configuration, \%detector);

    # Tin Flag
    # Sn_flag = the piece that holds the target
    $detector{"name"} = "Tin_flag";
    $detector{"mother"} = "target";
    $detector{"description"} = "RGM Solid Target Flag Sn";
    $detector{"pos"} = "$Sn_f_x*cm $Sn_f_y*cm $row_flag*cm";
    $detector{"rotation"} = "$Sn_flag[3]*deg $Sn_flag[4]*deg $Sn_flag[5]*deg";
    $detector{"color"} = "009900";
    $detector{"type"} = "Box";
    $detector{"dimensions"} = "$Sn_flag[0]*cm $Sn_flag[1]*cm $Sn_flag[2]*cm";
    $detector{"material"} = "G4_Al";
    $detector{"style"} = 1;
    print_det(\%configuration, \%detector);

    # Carbon foil target
    $detector{"name"} = "Carbon_foil_target";
    $detector{"mother"} = "target";
    $detector{"description"} = "RGM Solid Target C";
    $detector{"pos"} = "$C_t_x*cm $C_t_y*cm $row_target*cm";
    $detector{"rotation"} = "$C_target[3]*deg $C_target[4]*deg $C_target[5]*deg";
    $detector{"color"} = "FF9300";
    $detector{"type"} = "Box";
    $detector{"dimensions"} = "$C_target[0]*cm $C_target[1]*cm $C_target[2]*cm";
    $detector{"material"} = "G4_C";
    $detector{"style"} = 1;
    print_det(\%configuration, \%detector);

    # TODO: remove lines
    # print("\n\nrow_target:\t\t\t\t $row_target [cm]\n");

    # Tin foil target
    $detector{"name"} = "Tin_foil_target";
    $detector{"mother"} = "target";
    $detector{"description"} = "RGM Solid Target Sn";
    $detector{"pos"} = "$Sn_t_x*cm $Sn_t_y*cm $row_target*cm";
    $detector{"rotation"} = "$Sn_target[3]*deg $Sn_target[4]*deg $Sn_target[5]*deg";
    $detector{"color"} = "0096FF";
    $detector{"type"} = "Box";
    $detector{"dimensions"} = "$Sn_target[0]*cm $Sn_target[1]*cm $Sn_target[2]*cm";
    $detector{"material"} = "G4_Sn";
    $detector{"style"} = 1;
    print_det(\%configuration, \%detector);

    # lAr target parameters
    $nplanes = 5;
    my @oradiusT = (2, 7.45, 7.425, 4.5, 1.5);             # With 0.1 mm spacing between the lAr and the windows
    my @z_planeT = (-27.37, -25.47, -25.0, -23.5, -22.63); # With 0.1 mm spacing between the lAr and the windows
    # my @oradiusT = (2, 7.45, 7.425, 4.5, 1.5);             # Without spacing between the lAr and the windows
    # my @z_planeT = (-27.47, -25.47, -25.0, -23.5, -22.53); # Without spacing between the lAr and the windows
    # my @oradiusT = (3, 7.5);         # Before updating into clas12Tags
    # my @z_planeT = (-27.47, -22.53); # Before updating into clas12Tags

    # Actual lAr target
    %detector = init_det();
    if ($configuration_string eq "rgm_fall2021_Ar") {
        $detector{"name"} = "lAr_target_cell";
    } elsif ($configuration_string eq "rgm_fall2021_C_v2_S" or $configuration_string eq "rgm_fall2021_C_v2_L") {
        $detector{"name"} = "Empty_target";
    }
    $detector{"mother"} = "target";
    $detector{"description"} = "Target Cell";
    if ($configuration_string eq "rgm_fall2021_Ar") {
        $detector{"color"} = "aa0000";
    } elsif ($configuration_string eq "rgm_fall2021_C_v2_S" or $configuration_string eq "rgm_fall2021_C_v2_L") {
        $detector{"color"} = "d9d9d9";
    }
    $detector{"type"} = "Polycone";
    $dimen = "0.0*deg 360*deg $nplanes*counts";
    for (my $i = 0; $i < $nplanes; $i++) {$dimen = $dimen . " 0.0*mm";}
    for (my $i = 0; $i < $nplanes; $i++) {$dimen = $dimen . " $oradiusT[$i]*mm";}
    for (my $i = 0; $i < $nplanes; $i++) {$dimen = $dimen . " $z_planeT[$i]*mm";}
    $detector{"dimensions"} = $dimen;
    if ($configuration_string eq "rgm_fall2021_Ar") {
        $detector{"material"} = "lAr_target"; # Custom material definition for liquid argon
    } elsif ($configuration_string eq "rgm_fall2021_C_v2_S" or $configuration_string eq "rgm_fall2021_C_v2_L") {
        $detector{"material"} = "G4_Galactic";
    }
    $detector{"style"} = 1;
    print_det(\%configuration, \%detector);

    # Upstream Al window. zpos comes from engineering model, has the shift of 1273.27 mm +  30 mm due to the new engineering center
    my $eng_shift = 1303.27; # original
    my $al_window_entrance_radius = 2.95; # From Bob (Entrance window diameter is 6 mm) - used smaller radius to 2.95 mm to approximate the window as flat and avoid overlap with the base tube, similar to the lD2 target
    my $al_window_entrance_thickness = 0.015; # From Bob (Entrance window thickness is 30 microns)
    my $zpos = $eng_shift - 1330.77 + $al_window_entrance_thickness; # From BM2101-02-00-0000 (8).pdf
    %detector = init_det();
    $detector{"name"} = "al_window_entrance";
    $detector{"mother"} = "target";
    $detector{"description"} = "30 mm thick aluminum window upstream";
    $detector{"color"} = "aaaaff";
    $detector{"type"} = "Tube";
    $detector{"dimensions"} = "0*mm $al_window_entrance_radius*mm $al_window_entrance_thickness*mm 0*deg 360*deg";
    $detector{"pos"} = "0*mm 0*mm $zpos*mm";
    $detector{"material"} = "G4_Al";
    $detector{"style"} = "1";
    print_det(\%configuration, \%detector);

    # # TODO: remove lines
    # print("\n\nz pos al_window_entrance:                     \t\t$zpos [mm]\n");
    # print("-((z pos al_window_entrance)-eng_shift):          \t\t" . (-($zpos-$eng_shift)) . " [mm]\n");
    # print("-((z pos al_window_entrance)-eng_shift-al_window_entrance_thickness):\t\t" . (-($zpos-$eng_shift-$al_window_entrance_thickness)) . " [mm]\n");
    # # print("z pos al_window_entrance:\t\t" . ($zpos/10) . " [cm]\n");
    # # print("z pos al_window_entrance-al_window_entrance_thickness:\t" . (($zpos-$al_window_entrance_thickness)/10) . " [cm]\n");
    # print("\n");

    # Downstream Al window
    $al_window_exit_radius = 5; # From Bob (Exit window diameter is 15 mm) - used smaller radius to 5 mm to approximate the window as flat, similar to the lD2 target
    $al_window_exit_thickness = 0.015; # From Bob (Exit window al_window_exit_thickness is 30 microns)
    $zpos = $eng_shift - 1325.77 - $al_window_exit_thickness; # From BM2101-02-00-0000 (8).pdf
    %detector = init_det();
    $detector{"name"} = "al_window_exit";
    $detector{"mother"} = "target";
    $detector{"description"} = "30 mm thick aluminum window downstream";
    $detector{"color"} = "aaaaff";
    $detector{"type"} = "Tube";
    $detector{"dimensions"} = "0*mm $al_window_exit_radius*mm $al_window_exit_thickness*mm 0*deg 360*deg";
    $detector{"pos"} = "0*mm 0*mm $zpos*mm";
    $detector{"material"} = "G4_Al";
    $detector{"style"} = "1";
    print_det(\%configuration, \%detector);

    # # TODO: remove lines
    # print("\n\nz pos al_window_exit:                     \t\t$zpos [mm]\n");
    # print("-((z pos al_window_exit)-eng_shift):          \t\t" . (-($zpos-$eng_shift)) . " [mm]\n");
    # print("-((z pos al_window_exit)-eng_shift+al_window_exit_thickness):\t\t" . (-($zpos-$eng_shift+$al_window_exit_thickness)) . " [mm]\n");
    # # print("z pos al_window_exit:\t\t" . ($zpos/10) . " [cm]\n");
    # # print("z pos al_window_exit-al_window_exit_thickness:\t" . (($zpos-$al_window_exit_thickness)/10) . " [cm]\n");
    # print("\n");

    # Scattering chambers al window, 75 microns
    # Note: the eng. position is 1017.27 - here it is placed 8mm upstream to place it within the mother scattering chamber
    $zpos = $eng_shift - 1025.27;
    $radius = 12;
    $thickness = 0.0375;
    %detector = init_det();
    $detector{"name"} = "al_window_scexit";
    $detector{"mother"} = "target";
    $detector{"description"} = "50 mm thick aluminum window downstream";
    $detector{"color"} = "aaaaff";
    $detector{"type"} = "Tube";
    $detector{"dimensions"} = "0*mm $radius*mm $thickness*mm 0*deg 360*deg";
    $detector{"pos"} = "0*mm 0*mm $zpos*mm";
    $detector{"material"} = "G4_Al";
    $detector{"style"} = "1";
    print_det(\%configuration, \%detector);
}

1;

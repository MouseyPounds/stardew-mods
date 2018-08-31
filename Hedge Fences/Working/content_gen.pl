#!/usr/bin/perl
#
# content.json entry generator for Hedge Fences mod

use strict;

# ConfigSchema texture choices and mapping to in-game name
my @flowers = qw(mixed pink blue yellow);
my @hedges = qw(dark light);
my @snow = qw(all half none);

# ConfigSchema options for which texture to replace.
# These need to be mapped to in-game recipe name, filename. object ID, and sprite coordinates
my %replace = (
	'Wood' => {
		'name' => 'Wood Fence',
		'obj_id' => 322,
		'filename' => 'Fence1',
		'obj_sprite' => '"X": 160, "Y": 208',
		},
	'Stone' => {
		'name' => 'Stone Fence',
		'obj_id' => 323,
		'filename' => 'Fence2',
		'obj_sprite' => '"X": 176, "Y": 208',
		},
	'Iron' => {
		'name' => 'Iron Fence',
		'obj_id' => 324,
		'filename' => 'Fence3',
		'obj_sprite' => '"X": 192, "Y": 208',
		},
	'Hardwood' => {
		'name' => 'Hardwood Fence',
		'obj_id' => 298,
		'filename' => 'Fence5',
		'obj_sprite' => '"X": 160, "Y": 192',
		},
	);
# ConfigSchema options for CraftingMaterial and associated object ID.
my %craft_mat = (
	'Fiber' => 771,
	'Wood' => 388,
	'Hardwood' => 709,
	);

# No output file, everything just prints to stdout and needs redirection because !lazy
select STDOUT;
print qq({\n\t"Format": "1.3",\n\t"ConfigSchema": {\n);
print qq(\t\t"ReplaceFence": {\n\t\t\t"AllowValues": ") . join(', ', (sort keys %replace)) . qq(",\n\t\t\t"Default": "Hardwood"\n\t\t},\n);
print qq(\t\t"CraftingMaterial": {\n\t\t\t"AllowValues":  ") . join(', ', (sort keys %craft_mat)) . qq(",\n\t\t\t"Default": "Hardwood"\n\t\t},\n);
print qq(\t\t"AddFlowers": {\n\t\t\t"AllowValues": "true, false",\n\t\t\t"Default": "true"\n\t\t},\n);
print qq(\t\t"FlowerType": {\n\t\t\t"AllowValues": ") . join(', ', (@flowers)) . qq(",\n\t\t\t"Default": "mixed"\n\t\t},\n);
print qq(\t\t"HedgeShade": {\n\t\t\t"AllowValues": ") . join(', ', (@hedges)) . qq(",\n\t\t\t"Default": "dark"\n\t\t},\n);
print qq(\t\t"SnowInWinter": {\n\t\t\t"AllowValues": ") . join(', ', (@snow)) . qq(",\n\t\t\t"Default": "all"\n\t\t},\n);
print qq(\t\t"FlowersInWinter": {\n\t\t\t"AllowValues": "true, false",\n\t\t\t"Default": "false"\n\t\t},\n);
print qq(\t},\n\t"Changes": [\n);

foreach my $r (sort keys %replace) {
	print <<"END_PRINT";
		{
			"Action": "EditImage",
			"Target": "LooseSprites/$replace{$r}{'filename'}",
			"FromFile": "assets/hedge_{{HedgeShade}}.png",
			"ToArea": { "X": 0, "Y": 0, "Width": 48, "Height": 128},
			"FromArea": { "X": 0, "Y": 0, "Width": 48, "Height": 128},
			"When": { "ReplaceFence": "$r" }
		},
		{
			"Action": "EditImage",
			"Target": "LooseSprites/$replace{$r}{'filename'}",
			"FromFile": "assets/hedge_{{HedgeShade}}.png",
			"PatchMode": "Overlay",
			"ToArea": { "X": 32, "Y": 160, "Width": 16, "Height": 32 },
			"FromArea": { "X": 32, "Y": 160, "Width": 16, "Height": 32 },
			"When": { "ReplaceFence": "$r" }
		},
		{
			"Action": "EditImage",
			"Target": "LooseSprites/$replace{$r}{'filename'}",
			"FromFile": "assets/flowers_{{FlowerType}}.png",
			"PatchMode": "Overlay",
			"Enabled": "{{AddFlowers}}",
			"When": { "ReplaceFence": "$r", "Season": "Spring, Summer, Fall" }
		},
		{
			"Action": "EditImage",
			"Target": "LooseSprites/$replace{$r}{'filename'}",
			"FromFile": "assets/flowers_{{FlowerType}}.png",
			"PatchMode": "Overlay",
			"Enabled": "{{AddFlowers}}",
			"When": { "ReplaceFence": "$r", "Season": "Winter" , "FlowersInWinter": "true" }
		},
		{
			"Action": "EditImage",
			"Target": "LooseSprites/$replace{$r}{'filename'}",
			"FromFile": "assets/snow.png",
			"PatchMode": "Overlay",
			"When": { "season": "winter", "ReplaceFence": "$r", "SnowInWinter": "all" }
		},
		{
			"Action": "EditImage",
			"Target": "LooseSprites/$replace{$r}{'filename'}",
			"FromFile": "assets/snow_half.png",
			"PatchMode": "Overlay",
			"When": { "season": "winter", "ReplaceFence": "$r", "SnowInWinter": "half" }
		},
		{
			"Action": "EditImage",
			"Target": "Maps/springobjects",
			"FromFile": "assets/hedge_{{HedgeShade}}.png",
			"ToArea": { $replace{$r}{'obj_sprite'}, "Width": 16, "Height": 16},
			"FromArea": { "X": 16, "Y": 64, "Width": 16, "Height": 16},
			"When": { "ReplaceFence": "$r" }
		},
		{
			"Action": "EditImage",
			"Target": "Maps/springobjects",
			"FromFile": "assets/flowers_{{FlowerType}}.png",
			"PatchMode": "Overlay",
			"ToArea": { $replace{$r}{'obj_sprite'}, "Width": 16, "Height": 16 },
			"FromArea": { "X": 16, "Y": 64, "Width": 16, "Height": 16 },
			"Enabled": "{{AddFlowers}}",
			"When": { "ReplaceFence": "$r", "Season": "Spring, Summer, Fall" }
		},
		{
			"Action": "EditImage",
			"Target": "Maps/springobjects",
			"FromFile": "assets/flowers_{{FlowerType}}.png",
			"PatchMode": "Overlay",
			"ToArea": { $replace{$r}{'obj_sprite'}, "Width": 16, "Height": 16 },
			"FromArea": { "X": 16, "Y": 64, "Width": 16, "Height": 16 },
			"Enabled": "{{AddFlowers}}",
			"When": { "ReplaceFence": "$r", "Season": "Winter" , "FlowersInWinter": "true" }
		},
		{
			"Action": "EditImage",
			"Target": "Maps/springobjects",
			"FromFile": "assets/snow.png",
			"PatchMode": "Overlay",
			"ToArea": { $replace{$r}{'obj_sprite'}, "Width": 16, "Height": 16 },
			"FromArea": { "X": 16, "Y": 64, "Width": 16, "Height": 16 },
			"When": { "season": "winter", "ReplaceFence": "$r", "SnowInWinter": "all"  }
		},
		{
			"Action": "EditImage",
			"Target": "Maps/springobjects",
			"FromFile": "assets/snow_half.png",
			"PatchMode": "Overlay",
			"ToArea": { $replace{$r}{'obj_sprite'}, "Width": 16, "Height": 16 },
			"FromArea": { "X": 16, "Y": 64, "Width": 16, "Height": 16 },
			"When": { "season": "winter", "ReplaceFence": "$r", "SnowInWinter": "half"  }
		},
		{
			"Action": "EditData",
			"Target": "Data/ObjectInformation",
			"Fields": {
				"$replace{$r}{'obj_id'}": { "0": "Hedge Fence", "1": "1", "4": "Hedge Fence" }
				},
			"When": { "ReplaceFence": "$r" }
		},
END_PRINT
	foreach my $m (sort keys %craft_mat) {
		# next if ($m eq 'NoChange');
		print <<"END_PRINT";
		{
			"Action": "EditData",
			"Target": "Data/CraftingRecipes",
			"Fields": { "$replace{$r}{'name'}": { 0: "$craft_mat{$m} 1", 2: "$replace{$r}{'obj_id'}" } },
			"When": { "ReplaceFence": "$r", "CraftingMaterial": "$m" }
		},
END_PRINT
	}
}
print qq(\t]\n}\n);

__END__

'# MWS Version: Version 2019.0 - Sep 20 2018 - ACIS 28.0.2 -

'# length = um
'# frequency = MHz
'# time = ns
'# frequency range: fmin = 800 fmax = 1200
'# created = '[VERSION]2019.0|28.0.2|20180920[/VERSION]


'@ use template: Progetto PWS - Antenna RFID.cfg

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
'set the units
With Units
    .Geometry "um"
    .Frequency "MHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With
'----------------------------------------------------------------------------
'set the frequency range
Solver.FrequencyRange "800", "1200"
'----------------------------------------------------------------------------
Plot.DrawBox True
With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With
' switch on FD-TET setting for accurate farfields
FDSolver.ExtrudeOpenBC "True"
MeshSettings.SetMeshType "HexTLM"
With MeshSettings
     .Set "RatioLimitGeometry", "20"
End With
' optimize mesh settings for planar structures
With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
End With
With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With
With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With
With FDSolver
	.ExtrudeOpenBC "False"
End With
' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)
MeshAdaption3D.SetAdaptionStrategy "Energy"
PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"
With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With
'----------------------------------------------------------------------------
Dim sDefineAt As String
sDefineAt = "868.6;915;953;954.2"
Dim sDefineAtName As String
sDefineAtName = "868.6;915;953;954.2"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")
Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)
Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)
' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With
' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With
' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With
Next
'----------------------------------------------------------------------------
With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With
With Mesh
     .MeshType "PBA"
End With
'set the solver type
ChangeSolverType("HF Time Domain")
'----------------------------------------------------------------------------

'@ define material: adesive_paper

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Material 
     .Reset 
     .Name "adesive_paper"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .HeatCapacity "0"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "um"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "2"
     .Mu "1"
     .Sigma "0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .EnableUserConstTanDModelOrderEps "False"
     .ConstTanDModelOrderEps "1"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .EnableUserConstTanDModelOrderMu "False"
     .ConstTanDModelOrderMu "1"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ new component: component1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Component.New "component1"

'@ define brick: component1:DIELETTRICO

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "DIELETTRICO" 
     .Component "component1" 
     .Material "adesive_paper" 
     .Xrange "-A_DIEL/2", "A_DIEL/2" 
     .Yrange "-B_DIEL/2", "B_DIEL/2" 
     .Zrange "-H_DIEL", "0" 
     .Create
End With

'@ define material: Aluminum

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Material
     .Reset
     .Name "Aluminum"
     .Folder ""
.FrqType "static"
.Type "Normal"
.SetMaterialUnit "Hz", "mm"
.Epsilon "1"
.Mu "1.0"
.Kappa "3.56e+007"
.TanD "0.0"
.TanDFreq "0.0"
.TanDGiven "False"
.TanDModel "ConstTanD"
.KappaM "0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstTanD"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.FrqType "all"
.Type "Lossy metal"
.MaterialUnit "Frequency", "GHz"
.MaterialUnit "Geometry", "mm"
.MaterialUnit "Time", "s"
.MaterialUnit "Temperature", "Kelvin"
.Mu "1.0"
.Sigma "3.56e+007"
.Rho "2700.0"
.ThermalType "Normal"
.ThermalConductivity "237.0"
.HeatCapacity "0.9"
.MetabolicRate "0"
.BloodFlow "0"
.VoxelConvection "0"
.MechanicsType "Isotropic"
.YoungsModulus "69"
.PoissonsRatio "0.33"
.ThermalExpansionRate "23"
.ReferenceCoordSystem "Global"
.CoordSystemType "Cartesian"
.NLAnisotropy "False"
.NLAStackingFactor "1"
.NLADirectionX "1"
.NLADirectionY "0"
.NLADirectionZ "0"
.Colour "1", "1", "0"
.Wireframe "False"
.Reflection "False"
.Allowoutline "True"
.Transparentoutline "False"
.Transparency "0"
.Create
End With

'@ define brick: component1:DIPOLO

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "DIPOLO" 
     .Component "component1" 
     .Material "Aluminum" 
     .Xrange "-A/2", "A/2" 
     .Yrange "G/2", "G/2+B" 
     .Zrange "0", "TD" 
     .Create
End With

'@ transform: mirror component1:DIPOLO

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "component1:DIPOLO" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:DIPOLO

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "component1:DIPOLO" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ delete shape: component1:DIPOLO_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "component1:DIPOLO_2"

'@ rename block: component1:DIPOLO to: component1:DIPOLO A

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Rename "component1:DIPOLO", "DIPOLO A"

'@ rename block: component1:DIPOLO_1 to: component1:DIPOLO B

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Rename "component1:DIPOLO_1", "DIPOLO B"

'@ change material and color: component1:DIPOLO A to: Aluminum

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.SetUseIndividualColor "component1:DIPOLO A", 1
Solid.ChangeIndividualColor "component1:DIPOLO A", "192", "192", "192"

'@ change material and color: component1:DIPOLO B to: Aluminum

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.SetUseIndividualColor "component1:DIPOLO B", 1
Solid.ChangeIndividualColor "component1:DIPOLO B", "192", "192", "192"

'@ activate local coordinates

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.ActivateWCS "local"

'@ move wcs

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "-H_DIEL"

'@ rotate wcs

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.RotateWCS "v", "180"

'@ move wcs

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "-H_DIEL"

'@ move wcs

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "H_DIEL"

'@ move wcs

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "H_DIEL"

'@ move wcs

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "-H_DIEL"

'@ perform cylindrical bending

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Bending
    .CylindricalBend "component1:DIELETTRICO", "True", "0", "50000", "-1"
    .CylindricalBend "component1:DIPOLO A", "True", "0", "50000", "-1"
    .CylindricalBend "component1:DIPOLO B", "True", "0", "50000", "-1"
End With

'@ define material: material1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Material 
     .Reset 
     .Name "material1"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .HeatCapacity "0"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "um"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "E_glass"
     .Mu "1"
     .Sigma "0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .EnableUserConstTanDModelOrderEps "False"
     .ConstTanDModelOrderEps "1"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .EnableUserConstTanDModelOrderMu "False"
     .ConstTanDModelOrderMu "1"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.533333", "1", "0.556863" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "90" 
     .Create
End With

'@ new component: BOTTIGLIA

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Component.New "BOTTIGLIA"

'@ define cylinder: BOTTIGLIA:VETRO

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Cylinder 
     .Reset 
     .Name "VETRO" 
     .Component "BOTTIGLIA" 
     .Material "material1" 
     .OuterRadius "R_BOTTLE" 
     .InnerRadius "R_BOTTLE-W_GLASS" 
     .Axis "y" 
     .Yrange "-H_BOTTLE/2", "H_BOTTLE/2" 
     .Xcenter "0" 
     .Zcenter "R_BOTTLE+H_DIEL" 
     .Segments "0" 
     .Create 
End With

'@ define material: WINE

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Material 
     .Reset 
     .Name "WINE"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .HeatCapacity "0"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "um"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "E_WINE"
     .Mu "1"
     .Sigma "tgD_WINE"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .EnableUserConstTanDModelOrderEps "False"
     .ConstTanDModelOrderEps "1"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .EnableUserConstTanDModelOrderMu "False"
     .ConstTanDModelOrderMu "1"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.705882", "0.294118", "0.368627" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "50" 
     .Create
End With

'@ define cylinder: BOTTIGLIA:WINE

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Cylinder 
     .Reset 
     .Name "WINE" 
     .Component "BOTTIGLIA" 
     .Material "WINE" 
     .OuterRadius "R_BOTTLE-W_GLASS" 
     .InnerRadius "0.0" 
     .Axis "y" 
     .Yrange "-H_BOTTLE/2", "H_BOTTLE/2" 
     .Xcenter "0" 
     .Zcenter "R_BOTTLE+H_DIEL" 
     .Segments "0" 
     .Create 
End With

'@ rename component: component1 to: TAG_RFID

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Component.Rename "component1", "TAG_RFID"

'@ define discrete port: 1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Label "" 
     .Folder "" 
     .Impedance "50.0" 
     .VoltagePortImpedance "0.0" 
     .Voltage "1.0" 
     .Current "1.0" 
     .SetP1 "False", "0.0", "G/2", "-TD" 
     .SetP2 "False", "0.0", "-G/2", "-TD" 
     .InvertDirection "False" 
     .LocalCoordinates "True" 
     .Monitor "True" 
     .Radius "0.0" 
     .Wire "" 
     .Position "end1" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set PBA version

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Discretizer.PBAVersion "2018092019"


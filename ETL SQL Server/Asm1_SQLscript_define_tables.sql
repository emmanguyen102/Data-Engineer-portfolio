USE DEP302x_ASM1
GO

if object_id(N'dbo.Type_DIM', N'U') is not null
drop table dbo.Type_DIM;
begin
CREATE TABLE dbo.Type_DIM
(
	typeID int identity(0,1) not null,
	type varchar(3),
	primary key (typeID)
)
end
go

IF OBJECT_ID(N'dbo.Person_DIM', N'U') IS NOT NULL
BEGIN
 CREATE TABLE Person_DIM
(
	personKey int identity(0,1) not null,
	RescuerID int,
	primary key (personKey)
)
END
go

IF OBJECT_ID(N'dbo.Color_DIM', N'U') IS NOT NULL
BEGIN
  CREATE TABLE Color_DIM
(
	colorID int identity(0,1) not null,
	Color1 varchar(255),
	Color2 varchar(255),
	Color3 varchar(255),
	primary key (colorID)
)
END
go

IF OBJECT_ID(N'dbo.Gender_DIM', N'U') IS NOT NULL
BEGIN
  CREATE TABLE Gender_DIM
(
	genderID int identity(0,1) not null,
	Gender varchar(6),
	primary key (genderID)
)
END
go

IF OBJECT_ID(N'dbo.State_DIM', N'U') IS NOT NULL
BEGIN
  CREATE TABLE State_DIM
(
	stateID int identity(0,1) not null,
	stateName varchar(255),
	primary key (stateID)
)
END
go

IF OBJECT_ID(N'dbo.Breed_DIM', N'U') IS NOT NULL
BEGIN
  CREATE TABLE Breed_DIM
(
	breedID int identity(0,1) not null,
	Breed1 varchar(255),
	Breed2 varchar(255),
	primary key (breedID)
)
END
go

IF OBJECT_ID(N'dbo.Med_DIM', N'U') IS NOT NULL
BEGIN
  CREATE TABLE Med_DIM
(
	healthID int identity(0,1) not null,
	Vaccinated varchar(255),
	Dewormed varchar(255),
	Sterilized varchar(255),
	primary key (healthID)
)
END
go

IF OBJECT_ID(N'dbo.PetDesc_DIM', N'U') IS NOT NULL
BEGIN
  CREATE TABLE PetDesc_DIM
(
	PetKey int identity(0,1) not null,
	PetName nvarchar(255),
	MaturitySize varchar(13),
	FurLength varchar(13),
	Health varchar(14),
	primary key (PetKey)
)
END
go

IF OBJECT_ID(N'Pet_FACT', N'U') IS NOT NULL
BEGIN
  CREATE TABLE Pet_FACT 
(
	PetID int identity(0,1) not null,
	Age int,  
	Quantity int,
	Fee int,
	dim_type_id int,
	dim_state_id int,
	dim_person_id int,
	dim_breed_id int,
	dim_color_id int,
	dim_gender_id int,
	dim_med_id int,
	dim_pet_desc_key int,
	primary key (PetID),
	foreign key (dim_type_id) references Type_DIM(typeID),
	foreign key (dim_state_id) references State_DIM(stateID),
	foreign key (dim_breed_id) references Breed_DIM(breedID),
	foreign key (dim_gender_id) references Gender_DIM(genderID),
	foreign key (dim_color_id) references Color_DIM(colorID),
	foreign key (dim_med_id) references Med_DIM(healthID),
	foreign key (dim_person_id) references Person_DIM(personKey),
	foreign key (dim_pet_desc_key) references PetDesc_DIM(PetKey)
)
END
go

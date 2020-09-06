-- # Person. Our 'Base' class for a set of more complex classes.
local Person = {} -- # Use Person(name, age, sex) to use as an instance constructor.
Person.__index = Person
setmetatable(Person, {
  __call = function(_, name, age, sex)
  	local person = {
      name = name,
      age = age,
      sex = sex
    }
    
    return setmetatable(person, Person)
  end
})

function Person:introduce()
  return ("Hello, my name is %s."):format(self.name)
end

function Person:greet(otherPerson)
  return self:introduce() .. (" Nice to meet you %s."):format(otherPerson.name)
end


-- # Now we can create 'Persons' or 'instances' of Persons as we call them in OOP.
local bob = Person('Bob', 49, 'male')
local jane = Person('Jane', 33, 'female')

print( bob:greet(jane) ) -- # > "Hello, my name is Bob. Nice to meet you Jane."

-- # This is where OOP really shines and why it would be recommeneded. 'Inheritance'.
local Wizard = {}
Wizard.__index = Wizard

setmetatable(Wizard, {
  __call = function(_, name, age, sex, spells)
  	local wizard = Person(name, age, sex) -- # create a wizard from the Person class. Wizards are people too. Not all People are Wizards.
    wizard.spells = spells -- # Wizard specific
    
    return setmetatable(wizard, Wizard) -- # bestow Wizard methods upon wizard instance.
  end,
  
  -- # inheritance
  __index = Person -- # If a method or field isn't within a 'Wizard' then fallback to the 'Base' which is 'Person'. i.e wizardInstance:greet(bob)
})

-- # Sub-class method override.
function Wizard:introduce() -- # Wizard introductions should state the prestige that they are Wizards!
  return ("Hello, my name is %s the wizard."):format(self.name)
end

-- # Wizard:greet is inherited from Person. 

function Wizard:cast(spell, target)
  assert(self.spells[spell], "Invalid spell. Your Wizard is weak.")
  return ("%s the wizard casts '%s' upon %s for %d damage."):format(self.name, spell, target.name, self.spells[spell].damage)
end

local merlin = Wizard("Merlin", 61, "male", {
  ["Abbra"] = {
  	name = "Abbra",
    damage = 12
  }
})

-- # Notice :greet() is inherited from Person class but uses the merlin instances version of :introduce()
print( merlin:greet(bob) ) -- # > "Hello, my name is Merlin the wizard. Nice to meet you Bob."
print( merlin:cast('Abbra', bob) ) -- # > "Merlin the wizard casts 'Abbra' upon Bob for 12 damage."

-- # End
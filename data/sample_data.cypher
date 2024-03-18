// To start fresh with an empty database:
MATCH (n) DETACH DELETE n

// Personas
  
CREATE
  (Sarah:Persona {name:'Sarah', pronouns:'she/her'}),
  (Zoey:Persona {name:'Zoey', pronouns:'she/her'}),
  (Jewel:Persona {name:'Jewel', pronouns:'they/them'}),
  (Thom:Persona {name:'Thom', pronouns:'he/him'}),
  (Jacob:Persona {name:'Jacob', pronouns:'undisclosed'})
  

// Coping Strategies
  
CREATE
  (Derealization:CopingStrategy {name:'Derealization'}),
  (Masking:CopingStrategy {name:'Masking'}),
  (Assimilating:CopingStrategy {name:'Assimilating'}),
  (Withdrawing:CopingStrategy {name:'Withdrawing'}),
  (Codeswitching:CopingStrategy {name:'Code Switching'}),
  (Withholding:CopingStrategy {name:'Withholding information'})


// Forms of Discrimination

CREATE
  (Ageism:Discrimination {name:'Ageism'}),
  (Classism:Discrimination {name:'Classism'}),
  (Racism:Discrimination {name:'Racism'}),
  (Colonialism:Discrimination {name:'Colonialism'}),
  (Queerphobia:Discrimination {name:'Queerphobia'}),
  (Homophobia:Discrimination {name:'homophobia'}),
  (Transphobia:Discrimination {name:'Transphobia'}),
  (Heteronormativity:Discrimination {name:'Heteronormativity'}),
  (ReligiousDiscrimination:Discrimination {name:'Religious discrimination'}),
  (Antisemitism:Discrimination {name:'Antisemitism'}),
  (Islamophobia:Discrimination {name:'Islamophobia'}),
  (Ableism:Discrimination {name:'Ableism'}),
  (Sexism:Discrimination {name:'Sexism'}),
  (ToxicMasculinity:Discrimination {name:'Toxic masculinity'}),
  (WhiteSupremacy:Discrimination {name:'White Supremacy'})

CREATE
  (Antisemitism)-[:EXTENDS]->(ReligiousDiscrimination),
  (Islamophobia)-[:EXTENDS]->(ReligiousDiscrimination),
  (Queerphobia)-[:EXTENDS]->(Heteronormativity),
  (Homophobia)-[:EXTENDS]->(Heteronormativity),
  (Transphobia)-[:EXTENDS]->(Heteronormativity),
  (Racism)-[:EXTENDS]->(WhiteSupremacy),
  (Colonialism)-[:EXTENDS]->(WhiteSupremacy),
  (Heteronormativity)-[:EXTENDS]->(WhiteSupremacy),
  (Sexism)-[:EXTENDS]->(WhiteSupremacy),
  (ToxicMasculinity)-[:EXTENDS]->(WhiteSupremacy)


// Feelings

CREATE
  (Alienation:Feeling {name:'Alienation'}),
  (Fear:Feeling {name:'Fear'}),
  (Hopelessness:Feeling {name:'Hopelessness'}),
  (Anger:Feeling {name:'Anger'})

CREATE
  (Ageism)-[:PROVOKES]->(Alienation),
  (Classism)-[:PROVOKES]->(Alienation),
  (Sexism)-[:PROVOKES]->(Anger),
  (Sexism)-[:PROVOKES]->(Fear),
  (Sexism)-[:PROVOKES]->(Alienation),
  (Racism)-[:PROVOKES]->(Alienation),
  (Racism)-[:PROVOKES]->(Anger),
  (Racism)-[:PROVOKES]->(Fear),
  (Queerphobia)-[:PROVOKES]->(Fear),
  (Queerphobia)-[:PROVOKES]->(Alienation),
  (Transphobia)-[:PROVOKES]->(Fear),
  (Transphobia)-[:PROVOKES]->(Alienation)

  
// Age

CREATE
  (Age:Identity {name:'Age'}),
  (Teens:Identity {name:'Teens'}),
  (Twenties:Identity {name:'Twenties'}),
  (Thirties:Identity {name:'Thirties'}),
  (Forties:Identity {name:'Forties'}),
  (Fifties:Identity {name:'Fifties'}),
  (Sixties:Identity {name:'Sixties'}),
  (Teens)-[:EXTENDS]->(Age),
  (Twenties)-[:EXTENDS]->(Age),
  (Thirties)-[:EXTENDS]->(Age),
  (Forties)-[:EXTENDS]->(Age),
  (Fifties)-[:EXTENDS]->(Age),
  (Sixties)-[:EXTENDS]->(Age),
  (Age)-[:ATTRACTS]->(Ageism),
  (Teens)-[:ATTRACTS]->(Ageism),
  (Forties)-[:ATTRACTS]->(Ageism),
  (Fifties)-[:ATTRACTS]->(Ageism),
  (Sixties)-[:ATTRACTS]->(Ageism)

CREATE
  (Sarah)-[:BELONGS_WITH]->(Thirties),
  (Zoey)-[:BELONGS_WITH]->(Fifties),
  (Jewel)-[:BELONGS_WITH]->(Fifties),
  (Thom)-[:BELONGS_WITH]->(Twenties),
  (Jacob)-[:BELONGS_WITH]->(Teens)

CREATE
  (Zoey)-[:EMPLOYS]->(Withholding)-[:RESPONDING_TO]->(Ageism)

// Socio-economic Class

CREATE
  (Class:Identity {name:'Class'}),
  (Lower:Identity {name:'Lower Class'}),
  (Middle:Identity {name:'Middle Class'}),
  (Upper:Identity {name:'Upper Class'}),
  (Lower)-[:EXTENDS]->(Class),
  (Middle)-[:EXTENDS]->(Class),
  (Upper)-[:EXTENDS]->(Class),
  (Class)-[:ATTRACTS]->(Classism),
  (Lower)-[:ATTRACTS]->(Classism)

CREATE
  (Sarah)-[:BELONGS_WITH]->(Upper),
  (Zoey)-[:BELONGS_WITH]->(Lower),
  (Jewel)-[:BELONGS_WITH]->(Lower),
  (Thom)-[:BELONGS_WITH]->(Middle),
  (Jacob)-[:BELONGS_WITH]->(Lower)
  
CREATE
  (Jacob)-[:EMPLOYS]->(Assimilating)-[:RESPONDING_TO]->(Classism),
  (Jewel)-[:EMPLOYS]->(Assimilating)-[:RESPONDING_TO]->(Classism),
  (Jewel)-[:EMPLOYS]->(Withholding)-[:RESPONDING_TO]->(Classism)
  

// Race/Ethnicity

CREATE    
  (Race:Identity {name:'Race'}),
  (White:Identity {name:'White'}),
  (Black:Identity {name:'Black'}),
  (Bipoc:Identity {name:'BIPOC'}),
  (Latinx:Identity {name:'Latinx'}),
  (Indigenous:Identity {name:'Indigenous'}),
  (White)-[:EXTENDS]->(Race),
  (Black)-[:EXTENDS]->(Race),
  (Bipoc)-[:EXTENDS]->(Race),
  (Latinx)-[:EXTENDS]->(Race),
  (Other)-[:EXTENDS]->(Race),
  (Black)-[:EXTENDS]->(Bipoc),
  (Latinx)-[:EXTENDS]->(Bipoc),
  (Indigenous)-[:EXTENDS]->(Bipoc),
  (Bipoc)-[:ATTRACTS]->(Racism),
  (Indigenous)-[:ATTRACTS]->(Colonialism)

CREATE
  (Codeswitching)-[:RESPONDING_TO]->(Racism),
  (Assimilating)-[:RESPONDING_TO]->(Racism)
    
CREATE
  (Sarah)-[:BELONGS_WITH]->(White),
  (Zoey)-[:BELONGS_WITH]->(Black),
  (Jewel)-[:BELONGS_WITH]->(Bipoc),
  (Thom)-[:BELONGS_WITH]->(Indigenous),
  (Jacob)-[:BELONGS_WITH]->(Black)
    
CREATE
  (Jacob)-[:EMPLOYS]->(Assimilating)-[:RESPONDING_TO]->(Racism),
  (Jacob)-[:EMPLOYS]->(Codeswitching)-[:RESPONDING_TO]->(Racism),
  (Jewel)-[:EMPLOYS]->(Withholding)-[:RESPONDING_TO]->(Racism)
  

// LGBTQIA Status

CREATE
  (Lgbtqia:Identity {name:'LGBTQIA+'}),
  (Queer:Identity {name:'Queer'}),
  (Nonbinary:Identity {name:'Nonbinary'}),
  (Trans:Identity {name:'Transgender'}),
  (Gay:Identity {name:'Gay'}),
  (Queer)-[:EXTENDS]->(Lgbtqia),
  (Nonbinary)-[:EXTENDS]->(Lgbtqia),
  (Trans)-[:EXTENDS]->(Lgbtqia),
  (Gay)-[:EXTENDS]->(Lgbtqia),
  (Queer)-[:ATTRACTS]->(Queerphobia),
  (Nonbinary)-[:ATTRACTS]->(Heteronormativity),
  (Nonbinary)-[:ATTRACTS]->(Queerphobia),
  (Trans)-[:ATTRACTS]->(Transphobia),
  (Queer)-[:ATTRACTS]->(Homophobia)

CREATE
  (Zoey)-[:BELONGS_WITH]->(Trans),
  (Zoey)-[:BELONGS_WITH]->(Queer),
  (Jewel)-[:BELONGS_WITH]->(Nonbinary),
  (Thom)-[:BELONGS_WITH]->(Queer),
  (Jacob)-[:BELONGS_WITH]->(Gay)
      
CREATE
  (Jacob)-[:EMPLOYS]->(Assimilating)-[:RESPONDING_TO]->(Homophobia),
  (Jewel)-[:EMPLOYS]->(Assimilating)-[:RESPONDING_TO]->(Transphobia),
  (Thom)-[:EMPLOYS]->(Withholding)-[:RESPONDING_TO]->(Queerphobia)
  
  
// Religion

CREATE
  (Religious:Identity {name:'Religious'}),
  (Catholic:Identity {name:'Catholic'}),
  (Protestant:Identity {name:'Protestant'}),
  (Pagan:Identity {name:'Pagan'}),
  (Agnostic:Identity {name:'Agnostic'}),
  (Atheist:Identity {name:'Atheist'}),
  (Muslim:Identity {name:'Muslim'}),
  (Jewish:Identity {name:'Jewish'}),
  (Catholic)-[:EXTENDS]->(Religious),
  (Protestant)-[:EXTENDS]->(Religious),
  (Pagan)-[:EXTENDS]->(Religious),
  (Agnostic)-[:EXTENDS]->(Religious),
  (Atheist)-[:EXTENDS]->(Religious),
  (Muslim)-[:EXTENDS]->(Religious),
  (Jewish)-[:EXTENDS]->(Religious),
  (Jewish)-[:ATTRACTS]->(Antisemitism),
  (Muslim)-[:ATTRACTS]->(Islamophobia),
  (Religious)-[:ATTRACTS]->(ReligiousDiscrimination)

CREATE
  (Sarah)-[:BELONGS_WITH]->(Agnostic),
  (Zoey)-[:BELONGS_WITH]->(Agnostic),
  (Jewel)-[:BELONGS_WITH]->(Atheist),
  (Thom)-[:BELONGS_WITH]->(Jewish),
  (Jacob)-[:BELONGS_WITH]->(Muslim)

CREATE
  (Jacob)-[:EMPLOYS]->(Withholding)-[:RESPONDING_TO]->(Islamophobia),
  (Thom)-[:EMPLOYS]->(Assimilating)-[:RESPONDING_TO]->(Antisemitism)
          
// Disability

CREATE
  (Disability:Identity {name:'Disability'}),
  (Diabetic:Identity {name:'Diabetic'}),
  (Blind:Identity {name:'Blind'}),
  (Immunocompromised:Identity {name:'Immunocompromised'}),
  (Diabetic)-[:EXTENDS]->(Disability),
  (Blind)-[:EXTENDS]->(Disability),
  (Immunocompromised)-[:EXTENDS]->(Disability),
  (Disability)-[:ATTRACTS]->(Ableism)

CREATE
  (Jewel)-[:BELONGS_WITH]->(Diabetic)  

CREATE
  (Jewel)-[:EMPLOYS]->(Withholding)-[:RESPONDING_TO]->(Ableism)
  

// Neurodivergence
  
CREATE
  (Neurodivergent:Identity {name:'Neurodivergent'}),
  (Bipolar:Identity {name:'Bipolar'}),
  (Austistic:Identity {name:'Austistic'}),
  (Bipolar)-[:EXTENDS]->(Neurodivergant),
  (Autistic)-[:ATTRACTS]->(Ableism)

CREATE
  (Jacob)-[:BELONGS_WITH]->(Autistic)

CREATE
  (Jacob)-[:EMPLOYS]->(Masking)-[:RESPONDING_TO]->(Ableism)
  
      
// Gender

CREATE
  (Gender:Identity {name:'Gender'}),
  (Female:Identity {name:'Female'}),
  (Male:Identity {name:'Male'}),
  (UndisclosedGender:Identity {name:'Undisclosed gender'}),
  (Female)-[:EXTENDS]->(Gender),
  (Male)-[:EXTENDS]->(Gender),
  (Nonbinary)-[:EXTENDS]->(Gender),
  (UndisclosedGender)-[:EXTENDS]->(Gender),
  (Female)-[:ATTRACTS]->(Sexism),
  (Nonbinary)-[:ATTRACTS]->(Sexism),
  (Male)-[:ATTRACTS]->(ToxicMasculinity)

CREATE
  (Sarah)-[:BELONGS_WITH]->(Female),
  (Zoey)-[:BELONGS_WITH]->(Female),
  (Thom)-[:BELONGS_WITH]->(Male),
  (Jacob)-[:BELONGS_WITH]->(UndisclosedGender)
  
CREATE
  (Sarah)-[:EMPLOYS]->(Withdrawing)-[:RESPONDING_TO]->(Sexism),
  (Zoey)-[:EMPLOYS]->(Withdrawing)-[:RESPONDING_TO]->(Sexism),
  (Jacob)-[:EMPLOYS]->(Withdrawing)-[:RESPONDING_TO]->(Sexism)
      

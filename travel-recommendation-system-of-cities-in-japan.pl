% describe cities as facts
city(tokyo). city(osaka). city(kyoto). city(sapporo). city(fukuoka). 
city(yokohama). city(nagoya). city(kobe). city(hiroshima). city(nara).
city(tokyo, _, _, _, _).
city(osaka, _, _, _, _).
city(kyoto, _, _, _, _).
city(sapporo, _, _, _, _).
city(fukuoka, _, _, _, _).
city(yokohama, _, _, _, _).
city(nagoya, _, _, _, _).
city(kobe, _, _, _, _).
city(hiroshima, _, _, _, _).
city(nara, _, _, _, _).

% attractions
attraction(tokyo, 'tokyo tower', landmark). attraction(tokyo, 'asakusa shrine', shrine).
attraction(osaka, 'osaka castle', castle). attraction(osaka, 'dotonbori', entertainment_district).
attraction(kyoto, 'kinkaku-ji', temple). attraction(kyoto, 'fushimi inari-taisha', shrine).
attraction(sapporo, 'sapporo clock tower', historical_site). attraction(sapporo, 'moerenuma park', park).
attraction(fukuoka, 'ohori park', park). attraction(fukuoka, 'fukuoka tower', landmark).
attraction(yokohama, 'sankeien garden', garden). attraction(yokohama, 'cosmo clock 21', landmark).
attraction(nagoya, 'nagoya castle', castle). attraction(nagoya, 'atsumi hawaii park', park).
attraction(kobe, 'kobe port tower', landmark). attraction(kobe, 'nunobiki herb garden', garden).
attraction(hiroshima, 'hiroshima peace memorial', memorial). attraction(hiroshima, 'itsukushima shrine', shrine).
attraction(nara, 'todai-ji', temple). attraction(nara, 'nara park', park).

% climate
climate(tokyo, humid_subtropical). climate(osaka, humid_subtropical). climate(kyoto, humid_subtropical). climate(sapporo, humid_continental).
climate(fukuoka, humid_subtropical). climate(yokohama, humid_subtropical). climate(nagoya, humid_subtropical). climate(kobe, humid_subtropical).
climate(hiroshima, humid_subtropical). climate(nara, humid_subtropical).

% cost of living index 
cost_of_living(tokyo, 85). cost_of_living(osaka, 80). cost_of_living(kyoto, 75). cost_of_living(sapporo, 70).
cost_of_living(fukuoka, 78). cost_of_living(yokohama, 82). cost_of_living(nagoya, 80). cost_of_living(kobe, 78).
cost_of_living(hiroshima, 75). cost_of_living(nara, 73).

% transportation
transportation(tokyo, subway). transportation(osaka, subway). transportation(kyoto, bus). transportation(sapporo, tram).
transportation(fukuoka, subway). transportation(yokohama, train). transportation(nagoya, subway). transportation(kobe, train).
transportation(hiroshima, tram). transportation(nara, bus).

% languages spoken
language(tokyo, japanese). language(osaka, japanese). language(kyoto, japanese). language(sapporo, japanese).
language(fukuoka, japanese). language(yokohama, japanese). language(nagoya, japanese). language(kobe, japanese).
language(hiroshima, japanese). language(nara, japanese).

% currency
currency(tokyo, japanese_yen). currency(osaka, japanese_yen). currency(kyoto, japanese_yen). currency(sapporo, japanese_yen).
currency(fukuoka, japanese_yen). currency(yokohama, japanese_yen). currency(nagoya, japanese_yen). currency(kobe, japanese_yen).
currency(hiroshima, japanese_yen). currency(nara, japanese_yen).

% safety rating 
safety_rating(tokyo, 9). safety_rating(osaka, 8). safety_rating(kyoto, 9). safety_rating(sapporo, 8).
safety_rating(fukuoka, 8). safety_rating(yokohama, 9). safety_rating(nagoya, 8). safety_rating(kobe, 8).
safety_rating(hiroshima, 9). safety_rating(nara, 8).

% common dishes
dish(tokyo, sushi). dish(osaka, okonomiyaki). dish(kyoto, kaiseki). dish(sapporo, jingisukan). dish(fukuoka, tonkotsu_ramen). dish(yokohama, shumai).
dish(nagoya, hitsumabushi). dish(kobe, kobe_beef). dish(hiroshima, okonomiyaki). dish(nara, kakinoha_zushi).

% budget range
budget_range(tokyo, [high]). budget_range(osaka, [medium, high]). budget_range(kyoto, [medium, high]). 
budget_range(sapporo, [medium]). budget_range(fukuoka, [medium, high]). budget_range(yokohama, [medium, high]).
budget_range(nagoya, [medium, high]). budget_range(kobe, [medium]). budget_range(hiroshima, [medium, high]). 
budget_range(nara, [medium]).

% rule for printing city information
print_city_info(City) :-
    format('Discovering ~w:~n', [City]),
    print_city_property(City, 'Climate', climate),
    print_city_property(City, 'Cost of Living Index', cost_of_living),
    print_city_property(City, 'Safety Rating', safety_rating),
    print_city_property(City, 'Public Transportation', transportation),
    print_city_property_list(City, 'Languages Spoken', language),
    print_city_property(City, 'Currency', currency),
    print_city_property_list(City, 'Budget Range', budget_range),
    print_city_property_list(City, 'Common Dishes', dish),
    nl.

% print information about a specific property of a city
print_city_property(City, Label, Property) :-
    format('~w: ', [Label]),
    call(Property, City, PropertyValue),
    write(PropertyValue), nl.

% print information about a specific property of a city presesnt in a list
print_city_property_list(City, Label, Property) :-
    format('~w: ', [Label]),
    findall(Value, call(Property, City, Value), PropertyList),
    print_list(PropertyList),
    nl.
print_list([]) :- write('None'), nl.
print_list([H | T]) :-
    write(H),
    (T == [] -> nl ; write(', ')),
    print_list(T).

% ask user preferences and recommend city
get_preferences(RecommendedCity, RecommendedAttractions) :-
    write('Hello We are SM Travels.'), nl,
    write('We will recommend you a city to visit in Japan.'), nl,
    write('Let\'s start by getting your prefernces. '), nl,
    get_budget(Budget),
    get_climate(Climate),
    get_safety_rating(SafetyRating),
    get_transportation(Transportation),
    get_cost_of_living(CostOfLiving),
    get_attractions(Attractions),
    
    % find all citites that match maximum preferences
    findall((City, CityAttractions), recommend_city(City, Budget, Climate, SafetyRating, Transportation, CostOfLiving, Attractions, CityAttractions), CityAttractionsList),
    
    % for more than one matching city, choose one
    (CityAttractionsList \== [] ->
        random_member((RecommendedCity, RecommendedAttractions), CityAttractionsList),
        write('From what you chose, we would suggest you to visit  '), write(RecommendedCity), write('.'), nl,
        write('The Attractions in '), write(RecommendedCity), write(': '), write(RecommendedAttractions), nl;
        % if no perfectly matching city is found, recommend attractions of cities with similar attraction types
        write('There is no city in our database that matches perfectly with all your preferences.'), nl,
        recommend_similar_attractions(Attractions, RecommendedCity, RecommendedAttractions)).

% recommend cities with similar attraction type
recommend_similar_attractions(UserCategories, RecommendedCity, RecommendedAttractions) :-
    findall((City, Attractions), (
        city(City),
        attraction(City, _, Category),
        member(Category, UserCategories),
        findall(Attraction, attraction(City, Attraction, Category), Attractions)), CityAttractionsList),
    % for more than one matching cities, choose one randomly
    (CityAttractionsList \== [] ->
        random_member((RecommendedCity, RecommendedAttractions), CityAttractionsList),
        write('Based on the type of attractions you like, we recommend you to visit  '), write(RecommendedCity), write('.'), nl,
        write('The Attractions in '), write(RecommendedCity), write(': '), write(RecommendedAttractions), nl,
        % print the attractions for the recommended city
        findall(Attraction, attraction(RecommendedCity, Attraction, _), AllAttractions),
        length(AllAttractions, NumAllAttractions),
        (NumAllAttractions > 0 ->
            write('All the attractions in '), write(RecommendedCity), write(': '), write(AllAttractions), nl;
            true),
        % print detailed information about the recommended city
        print_city_info(RecommendedCity);
        % if no matching city is found, inform the user
        write('Sorry we can not find a city matching your attraction types. Try visiting ssome other country.'), nl).

% get the user budget and check
get_budget(Budget) :-
    write('Tell your preffered budget (low, medium, high): '), 
    read_line_to_string(user_input, BudgetString),
    check_budget(BudgetString, Budget).

check_budget(BudgetString, Budget) :-
    (member(BudgetString, ["low", "medium", "high"]) ->
        atom_string(Budget, BudgetString);
        write('Invalid input. Please enter "low", "medium", or "high".'), nl,
        get_budget(Budget)).

% get the user climate and check
get_climate(Climate) :-
    write('Tell your preffered climate (humid_subtropical, humid_continental): '), 
    read_line_to_string(user_input, ClimateString),
    check_climate(ClimateString, Climate).

check_climate(ClimateString, Climate) :-
    (member(ClimateString, ["humid_subtropical", "humid_continental"]) ->
        atom_string(Climate, ClimateString);
        write('Invalid input. Please enter a valid climate type.'), nl,
        get_climate(Climate)).

% get the user safety rating and check
get_safety_rating(SafetyRating) :-
    write('On a scale of 1 to 10, what is your preferred safety rating? '), 
    read_line_to_string(user_input, SafetyRatingString),
    check_safety_rating(SafetyRatingString, SafetyRating).

check_safety_rating(SafetyRatingString, SafetyRating) :-
    atom_number(SafetyRatingString, SafetyRating),
    SafetyRating >= 1, SafetyRating =< 10, 
    !.
check_safety_rating(_,_) :-
    write('Invalid input. Please enter a number between 1 and 10 for safety rating.'), nl,
    get_safety_rating(SafetyRating).

% get the user transportation and check
get_transportation(Transportation) :-
    write('What mode of public transportation do you prefer? (bus, subway, taxi, tram): '), 
    read_line_to_string(user_input, TransportationString),
    check_transportation(TransportationString, Transportation).

check_transportation(TransportationString, Transportation) :-
    member(TransportationString, ["bus", "subway", "taxi", "tram"]),
    atom_string(Transportation, TransportationString),
    !.
check_transportation(_, _) :-
    write('Invalid input. Please enter a valid mode of public transportation.'), nl,
    get_transportation(Transportation).

% get the user cost of living and check
get_cost_of_living(CostOfLiving) :-
    write('What\'s your preffered index of cost of living? (1-100): '), 
    read_line_to_string(user_input, CostOfLivingString),
    check_cost_of_living(CostOfLivingString, CostOfLiving).

check_cost_of_living(CostOfLivingString, CostOfLiving) :-
    atom_number(CostOfLivingString, CostOfLiving),
    CostOfLiving >= 1, CostOfLiving =< 100, 
    !.
check_cost_of_living(_, _) :-
    write('Invalid input. Please enter a number between 1 and 100 for cost of living index.'), nl,
    get_cost_of_living(CostOfLiving).


% get user preffered attractions and check
get_attractions(Categories) :-
    write('What type of attraction do you prefer? (e.g., temple, shrine, castle, entertainment_district, mountain, park, historical_site, landmark): '), 
    read_line_to_string(user_input, CategoriesString),
    check_attractions(CategoriesString, Categories).

check_attractions(CategoriesString, Categories) :-
    split_string(CategoriesString, ",", " ", CategoriesList),
    maplist(atom_string, Categories, CategoriesList),
    true.

% rule to recommend a city based on user preferences
recommend_city(City, Budget, Climate, SafetyRating, Transportation, CostOfLiving, UserCategories, Attractions) :-
    budget_range(City, BudgetRanges),
    member(Budget, BudgetRanges),
    climate(City, Climate),
    safety_rating(City, CitySafetyRating),
    transportation(City, Transportation),
    cost_of_living(City, CostOfLivingIndex),
    
    satisfies_categories(City, UserCategories, MatchingCategories),
    
    CitySafetyRating >= SafetyRating,
    CostOfLivingIndex =< CostOfLiving,
    
    findall(MatchingAttraction, (
        attraction(City, MatchingAttraction, MatchingCategory),
        member(MatchingCategory, MatchingCategories)), MatchingAttractions),
    length(MatchingAttractions, NumMatchingAttractions),
    
    (NumMatchingAttractions > 0 ->
        write('Attractions in '), write(City), write(' matching your preferences: '), write(MatchingAttractions), nl;
        true ),
    
    findall(Attraction, attraction(City, Attraction, _), Attractions),
    length(Attractions, NumAttractions),
    
    (NumAttractions > 0 ->
        write('All attractions in '), write(City), write(': '), write(Attractions), nl;
        true ),
    
    % Print detailed information about the city
    print_city_info(City).



% preferences staisfaction check
satisfies_categories(City, UserCategories, CommonCategories) :- 
    findall(Category, attraction(City, _, Category), CityCategories),
    intersection(UserCategories, CityCategories, CommonCategories).



?-get_preferences(RecommendedCity, RecommendedAttractions)

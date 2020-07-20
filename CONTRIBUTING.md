# A350-family Contributing Guidelines

These examples will show the Guidelines for contributing. Please follow this at all times, or your contribution will not be merged.

## Basic Guidelines:
- Use Tabs to indent code, DO NOT USE SPACE.
- Use lowerCamelCase for naming Nasal variables/functions (someFunction).
- Comments optional for XML, mandatory for Nasal.
- Do not add a comment to every line, only to functions/groups of code.
- Remove .bak or .blend files, unless absolutely needed.
- Always pull with `git pull --rebase` to avoid unneccesary merge commits.
- Always use descriptive commit messages
- Test _before_ commiting.

## Formatting Guidelines:
For new files adhere to the following, for existing files, maintain the used formatting.

Indenting and Line Breaks:
```
<!-- XML -->
<something>
	<something-else>0</something-else>
	<something-more>
		<more-stuff></more-stuff>
	</something-more>
</something>
```

```
# Nasal
var something = func
{
	somethingElse();
}
```
Brackets, Spaces, Commas, Semi-Colons, and Parentheses:
```
var something = 0;
var someOtherThing = func
{
	if (something == 1)
	{
		something = 0;
	}
	else
	{
		something = 1;
	}
	settimer(func
	{
		setprop("something", something);
	}, 5);
}
```

## Forks, Branches, and Merging
Please fork the repository, and commit your changes there. Branches are optional. When you are ready for us to look over you work, submit a pull request, following our pull request template, and a main Developer will look over it. If there is an issue that needs to be resolved before merging, the Developer will leave a comment on the pull request.

## Liveries
1. Liveries will be stored in a [separate repository](https://github.com/merspieler/A350-family-liveries). A small number of liveries may be possibly selected to be included with the aircraft.
2. All liveries should be as accurate as possible, within reason, particularly in terms of logos and colours.
3. All liveries must have historically or currently been used on the A350. No fictional liveries will be accepted to the main livery repository. Virtual Airline liveries are one exception, and may be stored in a dedicated part of the repository.
4. We will only have one example of each distinct livery of an airline.
5. Each livery must be created in 4096*4096 resolution. Lower and higher resolution versions may possibly be accepted in addition to the 4K variant.
6. The livery should be of (at the very least) reasonable quality, particularly, the livery should match up at UV boundaries with no mismatching.
7. The description should be in this format: ICAO Airline Name (Extra Info).
8. Liveries will be reviewed by a main contributor before being added.

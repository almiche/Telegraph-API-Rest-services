require 'json'


NewLetter='|'
NewWordDelimiter= ';'

file= File.read('alphaToMorse.json')
file= File.read('morseToalpha.json')
$alpha_to_morse=JSON.parse(file)
$morse_to_alpha=JSON.parse(file)

def decode(message_in_morse_code)

array_of_letters = message_in_morse_code.split("|")
$message = ""

array_of_letters.each do |morse_letter|
    real_letter = $morse_to_alpha[morse_letter]   
    $message << real_letter
end

    $message
end




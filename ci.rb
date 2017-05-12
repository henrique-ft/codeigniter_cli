arguments = ARGV

# Php code --------------------------------------------------------------------------

def phpFunction(name, arguments = [], inner = '', tab = '')
    
    arguments.map! do |argument|
        
        argument.strip!
        "$#{argument}"
    end

    arguments = arguments.join(', ')

    line = "#{tab}function #{name}(" << arguments << ")\n"
    line += "#{tab}{\n\n"
    line += inner
    line += "#{tab}}\n\n"
end

def phpMethod(privacity, name, arguments = [], inner = '', tab = "\t")
    
    arguments.map! do |argument|
        
        argument.strip!
        "$#{argument}"
    end

    arguments = arguments.join(', ')

    line = "#{tab}#{privacity} function #{name}(" << arguments << ")\n"
    line += "#{tab}{\n\n"
    line += inner
    line += "#{tab}}\n\n"
end

def phpClass(name, extends, inner = '',  tab = "\t")
    
    line += "class #{name.capitalize} extends #{extends} {\n\n"
    line += "#{tab}/**\n"
    line += "#{tab} * #{name.capitalize}\n"
    line += "#{tab} */\n"
    line += phpMethod('public','__construct')
    line += inner
    line += "}\n"
end

def phpFile(inner = '')

    line = "<?php \n\n"
    line += inner
end


# CodeIgniter Code ------------------------------------------------------------------

def ciClass(name, extends, inner = '',  tab = "\t")
    
    line = "defined('BASEPATH') OR exit('No direct script access allowed');\n\n"
    line += "class #{name.capitalize} extends #{extends} {\n\n"
    line += "#{tab}/**\n"
    line += "#{tab} * #{name.capitalize}\n"
    line += "#{tab} */\n"
    line += phpMethod('public','__construct',[],"\t\tparent::__construct();\n\n")
    line += inner
    line += "}\n"
end

def makeCiController(name, methods)
    
    file = File.new("application/controllers/#{name.capitalize}.php", "w")
    
    methods = methods.split('.').map! do |method_name|
        
        if method_name.count('-') != 0 && method_name.split('-')[1] != nil

            arguments = method_name.split('-')[1].split(',')
            method_name = method_name.split('-')[0]
        else

            arguments = []
            method_name.gsub!(/\W+/, '')
        end
        
        phpMethod('public', method_name, arguments)
    end

    
    file.write phpFile(ciClass(name.capitalize,'CI_Controller', methods.join))

    file.close

end


def makeCiModel(name, methods)
    
    file = File.new("application/models/#{name.capitalize}_model.php", "w")
    
    methods = methods.split('.').map! do |method_name|
        
        if method_name.count('-') != 0 && method_name.split('-')[1] != nil
        
            arguments = method_name.split('-')[1].split(',')
            method_name = method_name.split('-')[0]
            
        else
            
            arguments = []
            method_name.gsub!(/\W+/, '')
        end
        
        phpMethod('public', method_name, arguments)
    end
    
    file.write phpFile(ciClass(name.capitalize << '_model','CI_Model', methods.join))

    file.close

end


# Program ----------------------------------------------------------------------------

def home
    
    puts '------------------------------------------------------------------------------------------------------------------------------------'
    puts '| .+* . * + . * . *+ . + * +.* + + . + * .+ *. *.+ + . * .* Ruby Ci .+* . * + . * . *+ . + * +.* + + . + * .+ *. *.+ + . * .* . *  |'
    puts '------------------------------------------------------------------------------------------------------------------------------------'
    puts '# ruby ci c     create controllers    ex: ruby ci c mycontroller/mymethod.mysecondmethod.mythirdmethodwithparamns-par1=false,par2'
    puts '# ruby ci m     create models         ex: ruby ci m mymodel/mymethod.mysecondmethod.mythirdmethodwithparamns-par1=0,par2'
    puts "------------------------------------------------------------------------------------------------------------------------------------\n"
end

case arguments.shift

    when 'c'
        
        arguments.each do |argument|
            
            if argument.count('/') != 0 && argument.split('/')[1] != nil
                
                name = argument.split('/')[0]
                methods = argument.split('/')[1]
            else
                
                name = argument
                methods = ''
            end
        
            makeCiController(name, methods)
            
            puts ".+* Controller #{name} .. Done"
        end

    when 'm'
        
        arguments.each do |argument|
            
            if argument.count('/') != 0 && argument.split('/')[1] != nil
                
                name = argument.split('/')[0]
                methods = argument.split('/')[1]
            else
                
                name = argument
                methods = ''
            end
        
            makeCiModel(name, methods)

            puts ".+* Model #{name} .. Done"
        end
        
    else
        
        home
    
end

# help

# File.open("application/controllers/admin/Agentes.php", "r").each do |line|
    
#     puts line
# end


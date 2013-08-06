require 'logger'

class GeneticAlgorithm
  VERSION = '0.9.3'

  #
  # Must be initialized with an Array of "chromosomes". A chomosome object
  # must implement the methods `fitness`, `recombine` and `mutate`.
  #
  # population - initial population
  # options    - optional properties
  #
  # Options
  #
  # size   - maximum number of chromosomes in a generation [64].
  # logger - logger to write messages if given
  # io     - or argument to pass to Logger.new
  #
  def initialize(population, options = {})
    @population = population

    @size   = options[:size] || 64
    @logger = options[:logger] || Logger.new(options[:io] || '/dev/null')

    @generations = []
  end

  # Returns an array with the best fitted individuals for given
  # generation number ( by default from last generation ).
  def best_fit
    #@population.max_by(&:fitness)
    @population.sort_by(&:fitness).reverse
  end

  # Returns a GeneticAlgorithm object with the generations
  # loaded from given files and with properties prop.
  # Files must contain the chromosomes in YAML format.
  def self.populate_from_file(filename, prop = {})
    GeneticAlgorithm.new(YAML.load(File.open(filename, 'r')), prop)
  end

  # Saves into filename and in yaml format the generation that matchs with given
  # generation number ( by default from last generation ).
  def save_population(filename)
    f = File.new(filename, "w")
    f.write(@population.to_yaml)
    f.close
  end

  # EVOLUTION METHODS

  # Evolves the actual generation num_steps steps (1 by default).
  def evolve
    @population = selection(@population)
    new_gen = @population.map { |chromosome| chromosome.dup }
    @population += recombination(new_gen) + mutation(new_gen)
  end

  private

  # Selects population to survive and recombine
  def selection(g)
    if @size && g.length > @size
      g.sort{ |a, b| b.fitness <=> a.fitness }[0, @size]
    else
      g
    end
  end

  # Recombines population
  def recombination(g)
    log "Recombination " + g.size.to_s + " chromosomes."

    new_generation = g.shuffle
    log "Shuffled!"

    new_children = []
    new_generation.each_slice(2) do |chromosome1, chromosome2|
      next if chromosome2.nil?
      log "Recombining"
      childs = chromosome1.recombine(chromosome2)
      if Array === childs
        new_children += childs
      else
        new_children << childs
      end
    end
    new_generation + new_children
  end

  # Mutates population
  def mutation(gen)
    log "Mutation " + gen.size.to_s + " chromosomes."
    newgen = gen.dup.flatten
    newgen = newgen.map do |chromosome|
      log "Mutate"
      chromosome.mutate
    end
    newgen
  end

  #
  def log(message)
    @logger.debug(message) if @logger
  end

  ##
  #
  #
  class ChromosomeInterface
    def fitness
      raise NotImplementedError
    end

    def recombine(a, b)
      raise NotImplementedError
    end

    def mutate
      raise NotImplementedError
    end
  end

end

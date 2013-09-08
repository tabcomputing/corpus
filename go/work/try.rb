  def main
    srand(0)

    n = 10000000  # ten million
    a = randPerm(100)

    t0 = Time.now

    n.times do |i|
      a.index(i % 100)
    end

    puts "%.5f" % (Time.now - t0)
  end

  def randPerm(n)
    (0...n).sort_by{rand}
  end

  main()

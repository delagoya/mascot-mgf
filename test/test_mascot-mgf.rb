require 'mascot/mgf'

class TestMascotMgf < Test::Unit::TestCase
  def setup
    @mgf_file = File.open(File.expand_path("example.mgf"))
  end

  def test_canary
    asset true, "The canary does not sing"
  end
  
  def test_open_file
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
  end
  
  def test_get_first_and_second_query_string
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
    first_query =File.read("fixtures/first_query.mgf")
    first_query.strip!
    assert_equal(mgf.readquery(), first_query)
    second_query =File.read("fixtures/second_query.mgf")
    second_query.strip!
    assert_equal(mgf.readquery(), second_query)
  end

  def test_get_tenth_query_string
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
    tenth_query =File.read("fixtures/tenth_query.mgf")
    tenth_query.strip!
    # move cursor to tenth query
    mgf.pos = mgf.idx[9][0]
    assert_equal(mgf.readquery(), tenth_query)
  end

  def test_get_tenth_query_object
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
    # BEGIN IONS
    # TITLE=example.123.123.2
    # RTINSECONDS=760.3257
    # PEPMASS=643.77874755859375 367.44775390625
    # CHARGE=2
    tenth_query_title = 'example.123.123.2'
    tenth_query_rtinseconds = 760.3257
    tenth_query_pepmass = [643.77874755859375, 367.44775390625]
    tenth_query_charge = 2
    # move cursor to tenth query
    tenth_query = mgf.query(9)
    assert_equal(tenth_query.title, tenth_query_title)
    assert_equal(tenth_query.rtinseconds, tenth_query_rtinseconds)
    assert_equal(tenth_query.charge, tenth_query_charge)
    assert_equal(tenth_query.pepmass[0], tenth_query_pepmass[0])
    assert_equal(tenth_query.pepmass[1], tenth_query_pepmass[1])
  end    
end

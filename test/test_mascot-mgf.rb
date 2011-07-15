require 'test/unit'
require 'mascot/mgf'
class TestMascotMgf < Test::Unit::TestCase
  def setup
    @mgf_file = File.open(File.expand_path("test/fixtures/example.mgf"))
  end

  def test_canary
    assert true, "The canary does not sing"
  end

  def test_open_file
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
  end

  def test_get_first_and_second_query_string
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
    first_query =File.read("test/fixtures/first_query.mgf")
    # first_query = first_query.strip.chomp
    assert_equal(first_query,mgf.readquery())
    second_query =File.read("test/fixtures/second_query.mgf")
    # second_query = second_query.strip.chomp
    assert_equal( second_query,mgf.readquery())
  end

  def test_get_tenth_query_string
    mgf = Mascot::MGF.open(@mgf_file)
    assert_not_nil mgf
    tenth_query =File.read("test/fixtures/tenth_query.mgf")
    # move cursor to tenth query
    assert_equal(tenth_query,mgf.readquery(9))
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
    assert_equal(tenth_query_title, tenth_query.title)
    assert_equal(tenth_query_rtinseconds, tenth_query_rtinseconds)
    assert_equal(tenth_query_charge, tenth_query.charge)
    assert_equal(tenth_query_pepmass[0], tenth_query.pepmass[0])
    assert_equal(tenth_query_pepmass[1], tenth_query.pepmass[1])
  end

  def test_query_count
    mgf = Mascot::MGF.open(@mgf_file)
    assert_equal(13, mgf.query_count)
  end

  def test_create_cached_index
    mgf = Mascot::MGF.open(@mgf_file)
    assert(File.exists?(mgf.full_path + ".idx"))
  end
  def test_skip_cached_index
    # delete the index if it exists
    File.unlink(@mgf_file.path + ".idx")
    mgf = Mascot::MGF.open(@mgf_file,false)
    assert(!File.exists?(mgf.full_path + ".idx"))
  end
  def test_rewind_override
    mgf = Mascot::MGF.open(@mgf_file,false)
    first_query = mgf.query()
    second_query = mgf.query()
    mgf.rewind
    assert_equal(0,mgf.curr_index)
    assert_equal(first_query.title, mgf.query().title)
    assert_equal(1,mgf.curr_index)
    assert_equal(second_query.title, mgf.query().title)
  end
  def test_query_to_s
    first_query =File.read("test/fixtures/first_query.mgf")
    mgf = Mascot::MGF.open("test/fixtures/first_query.mgf")
    assert_equal(first_query, mgf.query.to_s)
  end
end

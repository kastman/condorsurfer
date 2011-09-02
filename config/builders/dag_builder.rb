# This function is used to build the dag that is submitted for each
# dataset. In many simple cases this can be left untouched.  However, there
# is great flexibility here and you can build an arbitrarily complex dag for
# each of your datasets which can buy you satisfying fault tolerance in Condor.
# When building your dag you can assume a Dataset object will be passed to this
# fuction which is a struct like:
#     Dataset = Struct.new :source, :sink, :filenames, :uniq
# where 'source' is the source directory for the dataset, 'sink' is the run time
# directory, and 'filenames' is an array of input data file names. 'uniq' is
# just the basename of the dataset source directory, but can be used as a unique
# identifier for the dataset in most cases
def build_dag(dataset)
  
  Scarcity::Dagger.new do
    
    # use the job statement to create nodes
    # job :head, 'null.submit'
    
    # jobs can take a block to specify dag configurations relevant to the node
    job :autorecon1, "condorsurfer.submit" do
      pre 'prejob.sh'
      post 'postjob.sh'
      vars :args => "#{dataset.uniq} 1 -nuintensitycor-3T",
      # vars :args => "#{dataset.uniq} 1",
           :exec => "condorsurfer.sh",
           :inputfiles => "#{dataset.uniq}.tar.gz"
      priority 5
      retries 3
    end

    job :autorecon2, "condorsurfer.submit" do
      pre 'prejob.sh'
      post 'postjob.sh'
      vars :args => "#{dataset.uniq} 2",
           :exec => "condorsurfer.sh",
           :inputfiles => "freesurfer_results.tar.gz"
      priority 5
      retries 3
    end
    
    job :autorecon3, "condorsurfer.submit" do
      pre 'prejob.sh'
      post 'postjob.sh'
      vars :args => "#{dataset.uniq} 3",
           :exec => "condorsurfer.sh",
           :inputfiles => "freesurfer_results.tar.gz"
      priority 5
      retries 3
    end
    
    breed :autorecon1, :children => :autorecon2
    breed :autorecon2, :children => :autorecon3
    
    # job :tail, 'null.submit'
    
    # breed parent nodes to define child nodes
    # breed :head,   :children => :main
    # breed :main,   :children => :tail

  end
  
end

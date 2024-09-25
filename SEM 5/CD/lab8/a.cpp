    void reduce_bdd() {
    bool changed = true;
    int size = mp2.size() - 1;

    while (changed) {
        changed = false;
        for (int i = size; i >= 0; i--) {
            set<int> removed;
            string temp = mp2[i];
            int temp_siz = nodes[temp].size();

            // Case 1: Handle identical subtrees
            if (temp_siz > 1) {
                for (int j = 0; j < temp_siz - 1; j++) {
                    if (removed.find(j) != removed.end()) continue;
                    for (int k = j + 1; k < temp_siz; k++) {
                        if (removed.find(k) != removed.end()) continue;
                        Node *n1 = nodes[temp][j];
                        Node *n2 = nodes[temp][k];

                        if ((n1->left == n2->left) && (n1->right == n2->right)) {
                            removed.insert(k);
                            changed = true;
                            // cout<<"hi"<<endl;
                            // cout<<n1->var<<j<<endl;
                            // cout<<n2->var<<k<<endl;
                            // cout<<n1->parents.size()<<endl;

                            // Redirect parents of n2 to n1
                            for (auto parent : n2->parents) {
                                if (parent->left == n2) {
                                    parent->left = n1;
                                } else {
                                    parent->right = n1;
                                }
                                n1->parents.insert(parent);
                            }

                            // Clear parents of n2 and safely delete
                            n2->parents.clear();
                            delete n2;  // Delete node n2 safely
                            // cout<<n1->parents.size()<<endl;
                        }
                    }
                }
            }
             for (auto it = removed.rbegin(); it != removed.rend(); ++it) {
                if (*it < nodes[temp].size()) {
                    nodes[temp].erase(nodes[temp].begin() + *it);
                }
            }
            removed.clear();
            
            temp_siz = nodes[temp].size();

            for (int j = 0; j < temp_siz; j++) {
                if (removed.find(j) != removed.end()) continue;
                Node *n = nodes[temp][j];

                if (n->left == n->right) {
                    changed = true;
                    removed.insert(j);

                    if (n == root) {
                        // Handle root node replacement
                        root = n->left ? n->left : n->right;
                        if (root) root->parents.clear();  // Clear root's parents if it's new
                    } else {
                        // Redirect parents of n to its left child
                        for (auto parent : n->parents) {
                            if (parent->left == n) {
                                parent->left = n->left;
                            }
                            
                            if(parent->right == n){
                                parent->right = n->left;
                            }
                            if (n->left) n->left->parents.insert(parent);
                        }
                    }

                    // Clear parents of n and safely delete
                    n->parents.clear();
                    delete n;  // Delete node n safely
                }
            }

            // Remove deleted nodes from the vector
            for (auto it = removed.rbegin(); it != removed.rend(); ++it) {
                if (*it < nodes[temp].size()) {
                    nodes[temp].erase(nodes[temp].begin() + *it);
                }
            }
        }
    }
}